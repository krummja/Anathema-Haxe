package domain.prefabs;

import domain.components.LightSource;
import domain.components.Vision;
import domain.components.Energy;
import domain.components.Position;
import domain.components.IsPlayer;
import domain.components.Sprite;
import ecs.Entity;
import hxd.Rand;
import common.struct.Coordinate;

class PlayerPrefab extends Prefab {
	public function create(options: Dynamic, pos: Coordinate) {
		var entity = new Entity(pos);

		entity.add(new Sprite(TK_PLAYER_01, C_WHITE, C_BLUE_1, ACTOR));
		entity.add(new IsPlayer());
		entity.add(new Position(pos.x, pos.y));
		entity.add(new Energy(10));
		entity.add(new Vision());

		return entity;
	}
}
