package engine;

import hxd.Rand;
import events.EntitySpawnedEvent;
import echoes.Echoes;
import echoes.Entity;
import common.struct.IntPoint;
import common.struct.Coordinate;
import prefabs.*;
import systems.*;
import components.*;

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

	public var spawner: Spawner;
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
		this.spawner = new Spawner();
	}

	public function initialize(): Void {
		this.rand = new Rand(seed);
		this.visible = [];

		this.zones.initialize();
		this.chunks.initialize();
		this.spawner.initialize();
		// this.map.initialize();

		this.systems.addSystem(ON_UPDATE, new EnergySystem());
		this.systems.addSystem(ON_UPDATE, new MovementSystem());
		this.systems.addSystem(POST_UPDATE, new RenderSystem());
		this.systems.activateAll();
	}

	public function start(seed: Int): Void {
		for (x in -10...10) {
			for (y in -10...10) {
				spawner.spawn(FLOOR, new Coordinate(x, y, WORLD));
			}
		}

		this.player.create(new Coordinate(0, 0, WORLD));
		this.player.entity.fireEvent(new EntitySpawnedEvent());

		var bat = spawner.spawn(BAT, new Coordinate(4, 4, WORLD));
		this.started = true;
	}

	public function update(): Void {
		this.systems.update();
	}

	public overload extern inline function getEntitiesAt(pos: IntPoint): Array<Entity> {
		var w = pos.asWorld();
		var idx = pos.asWorld().toChunkId();
		var chunk = chunks.getChunkById(idx);

		if (chunk == null) {
			return new Array<Entity>();
		}

		var local = w.toChunkLocal();
		var ids = chunk.getEntityIdsAt(local.x, local.y);

		var result = new Array<Entity>();
		var registry = Echoes.activeEntities;

		for (id in ids) {
			var entities = registry.filter((e) -> e.id == id);
			if (entities.length > 0) {
				result.concat(entities);
			}
		}

		return result;
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
