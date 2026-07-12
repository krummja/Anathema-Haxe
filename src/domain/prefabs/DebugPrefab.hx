package domain.prefabs;

import domain.components.Expiring;
import domain.components.Sprite;
import engine.ColorKey;
import ecs.Entity;
import common.struct.Coordinate;

class DebugPrefab extends Prefab {
	public function create(options: Dynamic, pos: Coordinate) {
		var entity = new Entity(pos);

		var color: ColorKey = options.color != null ? options.color : C_RED_0;
		entity.add(new Sprite(TK_RECT, color, C_BLACK, OBJECT));
		entity.add(new Expiring(3.0));

		return entity;
	}
}
