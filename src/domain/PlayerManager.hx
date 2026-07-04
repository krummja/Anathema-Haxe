package domain;

import domain.prefabs.Spawner;
import ecs.EntityRef;
import ecs.Entity;
import domain.prefabs.PlayerPrefab;
import domain.World;
import common.struct.Coordinate;
import domain.components.*;

class PlayerManager {
	public var entityRef: EntityRef;

	public var entity(get, null): Entity;
	public var x(get, null): Float;
	public var y(get, null): Float;
	public var pos(get, null): Coordinate;

	private var world(default, null): World;

	public function new(world: World) {
		this.entityRef = new EntityRef();
		this.world = world;
	}

	public function initialize() {}

	public function create(pos: Coordinate) {
		entityRef.entity = Spawner.spawn(PLAYER, pos);
	}

	private inline function get_x(): Float {
		return entity.pos.x;
	}

	private inline function get_y(): Float {
		return entity.pos.y;
	}

	private inline function get_pos(): Coordinate {
		return new Coordinate(this.x, this.y, WORLD);
	}

	private inline function get_entity(): Entity {
		return this.entityRef.entity;
	}
}
