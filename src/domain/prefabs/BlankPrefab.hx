package domain.prefabs;

import common.struct.Coordinate;
import engine.ColorKey;
import domain.components.Sprite;
import ecs.Entity;

class BlankPrefab extends Prefab {
	public function create(options: Dynamic, pos: Coordinate) {
		var entity = new Entity(pos);

		var color: ColorKey = options.color != null ? options.color : C_WHITE;
		entity.add(new Sprite(TK_BLANK, color, C_BLACK, OBJECT));

		return entity;
	}
}
