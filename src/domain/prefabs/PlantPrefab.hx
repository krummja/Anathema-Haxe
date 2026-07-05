package domain.prefabs;

import domain.components.Moniker;
import domain.components.LightBlocker;
import domain.components.Sprite;
import ecs.Entity;
import common.struct.Coordinate;

class PlantPrefab extends Prefab {
	public function create(options: Dynamic, pos: Coordinate) {
		var entity = new Entity(pos);

		entity.add(new Sprite(TK_TALL_GRASS_01, C_GREEN_1, C_GREEN_2, OBJECT));
		entity.add(new LightBlocker());
		entity.add(new Moniker("Tall grass"));

		return entity;
	}
}
