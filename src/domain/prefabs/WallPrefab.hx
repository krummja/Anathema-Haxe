package domain.prefabs;

import domain.components.LightBlocker;
import domain.components.BitmaskSprite;
import domain.components.Sprite;
import ecs.Entity;
import common.struct.Coordinate;

class WallPrefab extends Prefab {
	public function create(options: Dynamic, pos: Coordinate): Entity {
		var entity = new Entity(pos);

		entity.add(new Sprite(WALL_0, C_GRAY_3, C_GRAY_5, OBJECT));
		entity.add(new BitmaskSprite([
			BITMASK_WALL,
			BITMASK_WALL_THICK,
		]));
		entity.add(new LightBlocker());

		return entity;
	}
}
