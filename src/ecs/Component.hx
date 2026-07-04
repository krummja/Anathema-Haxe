package ecs;

import haxe.rtti.Meta;
import data.save.ComponentFields;
import engine.MainLoop;

abstract class Component {
	public var bit(get, null): Int = 0;
	public var type(get, null): String;
	public var entity(default, null): Entity;
	public var isAttached(get, null): Bool;

	public var instAllowMultiple(get, null): Bool;

	@:keep
	public static var allowMultiple(default, null): Bool;

	private var handlers: Map<String, (evt: EntityEvent) -> Void> = new Map();

	public function save(): Array<ComponentFields> {
		var cls = Type.getClass(this);
		var superCls = Type.getSuperClass(cls);
		var fields = Meta.getFields(cls);
		var superFields = Meta.getFields(superCls);
		var data = [];

		for (field in Reflect.fields(superFields)) {
			var metas = Reflect.field(superFields, field);
			var tags = Reflect.fields(metas);
			if (tags.contains("save")) {
				var value = Reflect.getProperty(this, field);
				data.push({
					f: field,
					v: value,
				});
			}
		}

		for (field in Reflect.fields(fields)) {
			var metas = Reflect.field(fields, field);
			var tags = Reflect.fields(metas);
			if (tags.contains("save")) {
				var value = Reflect.getProperty(this, field);
				data.push({
					f: field,
					v: value,
				});
			}
		}

		return data;
	}

	public function load(data: Array<ComponentFields>) {
		for (field in data) {
			Reflect.setProperty(this, field.f, field.v);
		}
	}

	private function addHandler<T: EntityEvent>(type: Class<T>, fn: (T) -> Void) {
		var className = Type.getClassName(type);
		handlers.set(className, cast fn);
	}

	private function onAttach() {}

	private function onRemove() {}

	@:allow(ecs.Entity)
	private function onEvent(evt: EntityEvent) {
		var cls = Type.getClass(evt);
		var className = Type.getClassName(cls);
		var handler = handlers.get(className);

		if (handler != null && isAttached) {
			handler(evt);
		}
	}

	@:allow(ecs.Entity)
	private function _attach(entity: Entity) {
		this.entity = entity;
		onAttach();
	}

	@:allow(ecs.Entity)
	private function _remove() {
		onRemove();
		entity = null;
	}

	private function get_bit(): Int {
		if (bit > 0) {
			return bit;
		}

		bit = MainLoop.getInstance().registry.register(Type.getClass(this));

		return bit;
	}

	private inline function get_type(): String {
		return Type.getClassName(Type.getClass(this));
	}

	private function get_isAttached(): Bool {
		return entity != null;
	}

	private function get_instAllowMultiple(): Bool {
		return Reflect.field(Type.getClass(this), 'allowMultiple');
	}
}
