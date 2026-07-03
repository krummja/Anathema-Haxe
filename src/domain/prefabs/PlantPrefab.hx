package domain.prefabs;

import domain.components.Position;
import domain.components.Sprite;
import ecs.Entity;
import common.struct.Coordinate;

class PlantPrefab extends Prefab {
	public function create(options: Dynamic, pos: Coordinate) {
		var entity = new Entity(pos);

		entity.add(new Sprite(TK_GRASS_01, C_GREEN_1, C_GREEN_2, OBJECT));
		entity.add(new Position(pos.x, pos.y));

		return entity;
	}
}
