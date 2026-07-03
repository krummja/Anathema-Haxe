package ecs;

import engine.MainLoop;

class EntityRef {
	var entityId: String;

	public var entity(get, set): Null<Entity>;

	public function new(id: String = '') {
		entityId = id;
	}

	private function get_entity(): Null<Entity> {
		return MainLoop.getInstance().registry.getEntity(entityId);
	}

	private function set_entity(value: Entity): Null<Entity> {
		entityId = value == null ? '' : value.id;
		return value;
	}
}
