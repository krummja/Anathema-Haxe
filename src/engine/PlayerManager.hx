package engine;

import engine.World;
import common.struct.Coordinate;
import components.*;
import prefabs.*;

class PlayerManager {
	public var entity(default, null): PlayerPrefab;

	public var x(get, null): Float;

	public var y(get, null): Float;

	public var pos(get, null): Coordinate;

	private var world(default, null): World;

	public function new(world: World) {
		this.world = world;
	}

	public function create(pos: Coordinate) {
		// entity = new PlayerPrefab(new Position(pos.x, pos.y));
	}

	private inline function get_x(): Float {
		return entity.position.x;
	}

	private inline function get_y(): Float {
		return entity.position.y;
	}

	private inline function get_pos(): Coordinate {
		return new Coordinate(this.x, this.y, WORLD);
	}
}
