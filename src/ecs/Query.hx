package ecs;

import bits.Bits;
import engine.MainLoop;

typedef QueryFilter = {
	var ?all: Array<Class<Component>>;
	var ?any: Array<Class<Component>>;
	var ?none: Array<Class<Component>>;
}

class Query {
	public var registry(get, null): Registry;
	public var size(default, null): Int;

	private var all: Bits;
	private var any: Bits;
	private var none: Bits;
	private var isDisposed: Bool;
	private var cache: Map<String, Entity>;

	private var onAddListeners: Array<(Entity) -> Void>;
	private var onRemoveListeners: Array<(Entity) -> Void>;

	public function new(filter: QueryFilter) {
		isDisposed = false;
		onAddListeners = new Array();
		onRemoveListeners = new Array();
		cache = new Map();
		size = 0;

		all = getBitmask(filter.all);
		any = getBitmask(filter.any);
		none = getBitmask(filter.none);

		registry.registerQuery(this);
		refresh();
	}

	public function setFilter(filter: QueryFilter) {
		all = getBitmask(filter.all);
		any = getBitmask(filter.any);
		none = getBitmask(filter.none);
		refresh();
	}

	/**
	 * Returns true if entity matches the query's filters.
	 */
	public function matches(entity: Entity): Bool {
		var flags = entity.flags;

		// TODO do better than counting
		var matchesAny = any.count() == 0 || flags.intersect(any).count() > 0;
		var matchesAll = flags.intersect(all).count() == all.count();
		var matchesNone = flags.intersect(none).count() == 0;

		return matchesAny && matchesAll && matchesNone;
	}

	public function candidate(entity: Entity) {
		var isTracking = cache.exists(entity.id);

		if (matches(entity)) {
			if (!isTracking) {
				size++;
				cache.set(entity.id, entity);

				for (listener in onAddListeners) {
					listener(entity);
				}
			}

			return true;
		}

		if (isTracking) {
			size--;
			cache.remove(entity.id);

			for (listener in onRemoveListeners) {
				listener(entity);
			}
		}

		return false;
	}

	public function refresh() {
		clearCache();
		for (entity in registry) {
			candidate(entity);
		}
	}

	public function clearCache() {
		size = 0;
		cache.clear();
	}

	public inline function iterator(): Iterator<Entity> {
		return new QueryIterator(this.cache);
	}

	public function onEntityAdded(fn: (Entity) -> Void) {
		onAddListeners.push(fn);
	}

	public function onEntityRemoved(fn: (Entity) -> Void) {
		onRemoveListeners.push(fn);
	}

	public function dispose() {
		isDisposed = true;
		onAddListeners = new Array();
		onRemoveListeners = new Array();
		cache = new Map();
		size = 0;
		registry.unregisterQuery(this);
	}

	private function getBitmask(components: Array<Class<Component>>): Bits {
		var bits = new Bits();

		if (components == null) {
			return bits;
		}

		for (c in components) {
			bits.set(registry.getBit(c));
		}

		return bits;
	}

	private inline function get_registry(): Registry {
		return MainLoop.getInstance().registry;
	}
}

class QueryIterator {
	var entities: Array<Entity> = [];
	var i: Int = 0;

	public inline function new(cache: Map<String, Entity>) {
		for (e in cache) { // TODO fix double iteration?
			entities.push(e);
		}
	}

	public inline function hasNext() {
		if (i >= entities.length) {
			return false;
		}

		var next = entities[i];

		if (next.isDestroyed) {
			i++;
			return hasNext();
		}

		return true;
	}

	public inline function next(): Entity {
		return entities[i++];
	}
}
