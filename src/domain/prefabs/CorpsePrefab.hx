package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class CorpsePrefab extends Prefab {
	public function create(options: Dynamic, pos: Coordinate) {
		var entity = new Entity(pos);

		entity.add(new Sprite(TK_BONES_01, C_WHITE, C_RED_0, OBJECT));
		entity.add(new Moniker("Corpse"));

		return entity;
	}
}
