package ecs;

import domain.components.Moniker;
import common.struct.FloatPoint;
import common.struct.IntPoint;
import common.struct.Cardinal;
import domain.components.Sprite;
import domain.events.EntityLoadedEvent;
import data.save.EntitySaveData;
import domain.components.IsDetached;
import common.util.UniqueId;
import common.struct.Coordinate;
import engine.Chunk;
import engine.MainLoop;
import bits.Bits;
import domain.events.MovedEvent;

class Entity {
	public static function load(data: EntitySaveData, tickDelta: Int = 0): Entity {
		var entity = new Entity(false);

		entity.isCandidacyEnabled = false;
		entity.setId(data.id);

		for (cdata in data.components) {
			var cls = Type.resolveClass(cdata.type);
			if (cls == null) {
				trace('Component not found (${cls})');
				continue;
			}

			var c = cast(Type.createInstance(cls, []), Component);
			c._attach(entity);
			c.load(cdata.data);

			entity.add(c);
		}

		entity.pos = new Coordinate(data.pos.x, data.pos.y, WORLD);
		entity.isDetachable = data.isDetachable;
		entity.isDetached = data.isDetached;

		if (entity.isDetached) {
			entity.registry.detachEntity(entity.id);
		}

		entity.isCandidacyEnabled = true;
		entity.registry.candidacy(entity);

		entity.fireEvent(new EntityLoadedEvent(tickDelta));
		return entity;
	}

	public var flags(default, null): Bits;
	public var id(default, null): String;
	public var pos(get, set): Coordinate;
	public var x(get, set): Float;
	public var y(get, set): Float;
	public var offset(default, set): Null<Coordinate>;
	public var chunk(get, never): Chunk;
	public var chunkIdx(get, never): Int;
	public var isDestroyed(default, null): Bool;
	public var isDetached(default, null): Bool;
	public var isDetachable: Bool;

	public var loop(get, null): MainLoop;
	public var registry(get, null): Registry;

	private var components: Map<String, Array<Component>>;
	private var isCandidacyEnabled: Bool = true;

	private var _x: Float;
	private var _y: Float;

	public function new(register: Bool = true, ?pos: Coordinate) {
		_x = 0;
		_y = 0;

		flags = new Bits(64);
		components = new Map();
		isDestroyed = false;
		isDetached = false;
		isDetachable = false;

		if (register) {
			setId(UniqueId.create());
		}

		if (pos != null) {
			this.pos = pos;
		}
	}

	public function setId(value: String) {
		id = value;
		registry.registerEntity(this);
	}

	public function destroy() {
		isCandidacyEnabled = false;
		for (component in components.copy()) {
			for (c in component.copy()) {
				remove(c);
			}
		}

		isCandidacyEnabled = true;
		isDestroyed = true;

		chunk.removeEntity(this);
		registry.unregisterEntity(this);
	}

	public function add(component: Component) {
		var type = Type.getClass(component);
		var clist = components.get(component.type);

		if (clist == null) {
			components.set(component.type, [component]);
		} else if (component.instAllowMultiple) {
			components.get(component.type).push(component);
		} else {
			if (has(type)) {
				remove(type);
			}

			components.set(component.type, [component]);
		}

		flags.set(component.bit);
		component._attach(this);

		if (isCandidacyEnabled) {
			registry.candidacy(this);
		}
	}

	public inline function has<T: Component>(type: Class<Component>): Bool {
		return flags.isSet(registry.getBit(type));
	}

	public function fireEvent<T: EntityEvent>(evt: T): T {
		for (component in components) {
			for (instance in component) {
				instance.onEvent(evt);
			}
		}

		return evt;
	}

	public overload extern inline function remove(component: Component) {
		removeInstance(component);
	}

	public overload extern inline function remove<T: Component>(type: Class<T>) {
		if (Reflect.field(type, 'allowMultiple')) {
			var cs = getAll(type);
			for (c in cs) {
				removeInstance(c);
			}
		} else {
			var c = get(type);
			if (c != null) {
				removeInstance(c);
			}
		}
	}

	public function getAll<T: Component>(type: Class<T>): Array<T> {
		var className = Type.getClassName(type);
		var cs = components.get(className);

		return cs == null ? [] : cast cs;
	}

	public function get<T: Component>(type: Class<T>): T {
		var className = Type.getClassName(type);
		var component = components.get(className);

		if (component == null) {
			return null;
		}

		return cast component[0];
	}

	public function detach() {
		isDetached = true;
		if (!has(IsDetached)) {
			add(new IsDetached());
			registry.detachEntity(id);
		}
	}

	public function reattach() {
		registry.reattachEntity(id);
		isDetached = false;
		remove(IsDetached);
	}

	public function save(): EntitySaveData {
		var cdata = components.flatten().map((c) -> ({
			type: c.type,
			data: c.save(),
		}));

		return {
			id: id,
			pos: {
				x: x,
				y: y,
			},
			isDetachable: isDetachable,
			isDetached: isDetached,
			components: cdata,
		};
	}

	private function removeInstance(component: Component) {
		if (component.instAllowMultiple) {
			var clist = components.get(component.type);
			if (clist != null) {
				clist.remove(component);
				if (clist.length == 0) {
					flags.unset(component.bit);
					components.remove(component.type);
				}
			}
		} else {
			flags.unset(component.bit);
			components.remove(component.type);
		}

		component._remove();

		if (isCandidacyEnabled) {
			registry.candidacy(this);
		}
	}

	private function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}

	private function get_registry(): Registry {
		return MainLoop.getInstance().registry;
	}

	private function set_pos(value: Coordinate): Coordinate {
		var prevChunkIdx = chunkIdx;
		var p = value.toPixel();
		var w = value.toWorld();

		_x = w.x;
		_y = w.y;

		var nextChunkIdx = chunkIdx;

		if (prevChunkIdx != nextChunkIdx) {
			var prevChunk = MainLoop.getInstance().world.chunks.getChunkById(prevChunkIdx);
			if (prevChunk != null) {
				prevChunk.removeEntity(this);
			}
		}

		var nextChunk = MainLoop.getInstance().world.chunks.getChunkById(nextChunkIdx);
		if (nextChunk != null) {
			nextChunk.setEntityPosition(this);
		}

		fireEvent(new MovedEvent(this, w));
		return w;
	}

	private function set_offset(value: Null<Coordinate>): Null<Coordinate> {
		var sprite = get(Sprite);

		var _delta = new Coordinate(0, 0, WORLD);

		if (sprite != null) {
			if (value != null) {
				_delta = value.sub(pos).toPixel();
			}

			var startPos = sprite.getPosition();
			sprite.setPosition(startPos.x + _delta.x, startPos.y + _delta.y);
		}

		return value;
	}

	private function get_pos(): Coordinate {
		return new Coordinate(_x, _y, WORLD);
	}

	private function set_x(value: Float): Float {
		set_pos(new Coordinate(value, _y, WORLD));
		return _x;
	}

	private function get_x(): Float {
		return _x;
	}

	private function set_y(value: Float): Float {
		set_pos(new Coordinate(_x, value, WORLD));
		return _y;
	}

	private function get_y(): Float {
		return _y;
	}

	private function get_chunk(): Chunk {
		return MainLoop.getInstance().world.chunks.getChunkById(chunkIdx);
	}

	private function get_chunkIdx(): Int {
		return pos.toChunkId();
	}
}
