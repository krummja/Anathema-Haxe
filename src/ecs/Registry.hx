package ecs;

import common.struct.Set;

class Registry {
	private var cbit: Int;
	private var bits: Map<String, Int>;
	private var queries: Array<Query>;
	private var entityMap: Map<String, Entity>;
	private var detached: Set<String>;

	public var size(default, null): Int;
	public var entities(get, never): Array<Entity>;

	public function new() {
		cbit = 0;
		size = 0;
		bits = new Map();
		entityMap = new Map();
		detached = new Set();
		queries = new Array();
	}

	/**
	 * Register a component class with the Registry.
	 * Returns the resulting cbit.
	 */
	public function register<T: Component>(type: Class<Component>): Int {
		var className = Type.getClassName(type);
		if (bits.exists(className)) {
			return bits.get(className);
		}

		bits.set(className, ++cbit);
		return cbit;
	}

	public function getEntity(entityId: String): Entity {
		return entityMap.get(entityId);
	}

	public function getBit<T: Component>(type: Class<Component>): Int {
		var className = Type.getClassName(type);
		var bit = bits.get(className);

		if (bit == null) {
			return register(type);
		}

		return bit;
	}

	public function candidacy(entity: Entity) {
		for (query in queries) {
			query.candidate(entity);
		}
	}

	public function getDetachedEntities(): Iterator<String> {
		return detached.iterator();
	}

	public function detachEntity(entityId: String) {
		detached.add(entityId);
	}

	public function reattachEntity(entityId: String) {
		detached.remove(entityId);
	}

	public function iterator(): Iterator<ecs.Entity> {
		return entityMap.iterator();
	}

	@:allow(ecs.Query)
	private function registerQuery(query: Query) {
		queries.push(query);
	}

	@:allow(ecs.Query)
	private function unregisterQuery(query: Query) {
		queries.remove(query);
	}

	@:allow(ecs.Entity)
	private function registerEntity(entity: Entity) {
		if (entityMap.exists(entity.id)) {
			trace('Given entity id ${entity.id} is already registered');
			return;
		}

		size++;
		entityMap.set(entity.id, entity);
	}

	@:allow(ecs.Entity)
	private function unregisterEntity(entity: Entity) {
		candidacy(entity);
		size--;
		entityMap.remove(entity.id);
		detached.remove(entity.id);
	}

	private function get_entities(): Array<Entity> {
		return [for (entity in entityMap.iterator()) entity];
	}
}
