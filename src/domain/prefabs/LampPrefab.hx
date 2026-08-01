package domain.prefabs;

import common.struct.Coordinate;
import domain.components.*;
import ecs.Entity;

class LampPrefab extends Prefab {
	public function create(options: Dynamic, pos: Coordinate): Entity {
		var isLit = options.isLit == null ? true : options.isLit;
		var entity = new Entity(pos);

		entity.add(new Sprite(TK_TILES_01, C_BLUE_0, C_CLEAR, OBJECT));
		entity.add(new LightSource(1.4, C_YELLOW_HC, 2, isLit));

		return entity;
	}
}
