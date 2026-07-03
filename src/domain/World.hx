package domain;

import hxd.Rand;
import ecs.Entity;
import common.struct.IntPoint;
import common.struct.Coordinate;
import domain.events.EntitySpawnedEvent;
import domain.PlayerManager;
import domain.SystemManager;
// import prefabs.*;
// import components.*;
import domain.prefabs.*;
import engine.*;

class World {
	public var loop(get, null): MainLoop;
	public var player(default, null): PlayerManager;
	public var behavior(default, null): BehaviorManager;
	public var chunks(default, null): ChunkManager;
	public var zones(default, null): ZoneManager;

	public var zoneCountX(default, null): Int = 64;
	public var zoneCountY(default, null): Int = 48;
	public var zoneSize(default, null): Int = 64;

	public var chunksPerZone(default, never): Int = 4;
	public var chunkSize(get, never): Int;
	public var chunkCountX(get, never): Int;
	public var chunkCountY(get, never): Int;

	public var worldWidth(get, null): Int;
	public var worldHeight(get, null): Int;

	public var systems(default, null): SystemManager;
	public var clock(default, null): Clock;
	public var started(get, null): Bool = false;

	public var rand: Rand;
	public var seed: Int = 2;

	private var visible: Array<Coordinate>;

	public function new() {
		this.systems = new SystemManager();
		this.clock = new Clock();
		this.player = new PlayerManager(this);
		this.behavior = new BehaviorManager();
		this.chunks = new ChunkManager();
		this.zones = new ZoneManager();
	}

	public function initialize(): Void {
		this.rand = new Rand(seed);
		this.visible = [];

		this.zones.initialize();
		this.chunks.initialize();
		this.systems.initialize();
		// this.map.initialize();
	}

	public function start(seed: Int): Void {
		this.player.create(new Coordinate(2, 2, WORLD));

		var plant = new PlantPrefab();
		plant.create({}, new Coordinate(4, 4, WORLD));

		this.started = true;
	}

	public function update(): Void {
		this.systems.update(loop.frame);
	}

	public overload extern inline function getEntitiesAt(pos: IntPoint): Array<Entity> {
		var chunkIdx = chunks.getChunkIdxByWorld(pos.x, pos.y);
		var chunk = chunks.getChunkById(chunkIdx);

		if (chunk == null) {
			return new Array<Entity>();
		}

		var localX = pos.x % chunkSize;
		var localY = pos.y % chunkSize;
		var ids = chunk.getEntityIdsAt(localX, localY);

		return ids.map((id: String) -> loop.registry.getEntity(id));
	}

	public overload extern inline function getEntitiesAt(pos: Coordinate): Array<Entity> {
		return getEntitiesAt(pos.toWorld().toIntPoint());
	}

	public inline function getTileIdx(pos: IntPoint) {
		return pos.y * worldWidth + pos.x;
	}

	public inline function getTilePos(idx: Int): IntPoint {
		var w = worldWidth;
		return {
			x: Math.floor(idx % w),
			y: Math.floor(idx / w),
		};
	}

	public inline function isOutOfBounds(pos: IntPoint): Bool {
		return pos.x < 0 || pos.y < 0 || pos.x > worldWidth || pos.y > worldHeight;
	}

	private function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}

	private function get_worldWidth(): Int {
		return this.chunkCountX * this.chunkSize;
	}

	private function get_worldHeight(): Int {
		return this.chunkCountY * this.chunkSize;
	}

	private function get_chunkCountX(): Int {
		return this.zoneCountX * this.chunksPerZone;
	}

	private function get_chunkCountY(): Int {
		return this.zoneCountY * this.chunksPerZone;
	}

	private function get_chunkSize(): Int {
		return Math.ceil(this.zoneSize / this.chunksPerZone);
	}

	private function get_started(): Bool {
		return started;
	}
}
