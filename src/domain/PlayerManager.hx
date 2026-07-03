package domain;

import domain.prefabs.PlayerPrefab;
import ecs.Entity;
import domain.World;
import common.struct.Coordinate;
import domain.components.*;

class PlayerManager {
	public var entity(default, null): Entity;

	public var x(get, null): Float;

	public var y(get, null): Float;

	public var pos(get, null): Coordinate;

	private var world(default, null): World;

	public function new(world: World) {
		this.world = world;
	}

	public function create(pos: Coordinate) {
		var prefab = new PlayerPrefab();
		this.entity = prefab.create({}, pos);
	}

	private inline function get_x(): Float {
		return entity.get(Position).x;
	}

	private inline function get_y(): Float {
		return entity.get(Position).y;
	}

	private inline function get_pos(): Coordinate {
		return new Coordinate(this.x, this.y, WORLD);
	}
}
