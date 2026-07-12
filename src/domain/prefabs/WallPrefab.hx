package domain.prefabs;

import domain.components.Collider;
import domain.components.Moniker;
import domain.components.LightBlocker;
import domain.components.Sprite;
import ecs.Entity;
import common.struct.Coordinate;

class WallPrefab extends Prefab {
	public function create(options: Dynamic, pos: Coordinate) {
		var entity = new Entity(pos);

		entity.add(new Sprite(TK_RECT, C_GRAY_1, C_BLACK, OBJECT));
		entity.add(new LightBlocker());
		entity.add(new Collider());
		entity.add(new Moniker("Generic wall"));

		return entity;
	}
}
