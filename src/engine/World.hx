package engine;

import events.ConsumeEnergyEvent;
import echoes.Entity;
import prefabs.Spawner;
import common.struct.IntPoint;
import common.struct.Coordinate;
import systems.RenderSystem;
import systems.MovementSystem;
import systems.EnergySystem;
import components.Position;
import prefabs.FloorPrefab;

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
		this.spawner.initialize();
		this.systems.addSystem(ON_UPDATE, new MovementSystem());
		this.systems.addSystem(ON_UPDATE, new EnergySystem());
		this.systems.addSystem(POST_UPDATE, new RenderSystem());
		this.systems.activateAll();
	}

	public function start(): Void {
		for (x in 0...3) {
			for (y in 0...3) {
				var pos = new Coordinate(x, y, WORLD);
				var floor = new FloorPrefab(new Position(pos.x, pos.y));
				floor.sprite.drawable.setPosition(pos.x, pos.y);
			}
		}

		// spawner.spawn(BAT, new Coordinate(4, 4, WORLD));
		this.player.create(new Coordinate(2, 2, WORLD));

		this.started = true;
	}

	public function update(): Void {
		this.systems.update();
	}

	public overload extern inline function getEntitiesAt(pos: IntPoint): Array<Entity> {
		// var w = pos.asWorld();
		// var idx = pos.asWorld().toChunkId();
		// var chunk = this.chunks.getChunkById(idx);

		// if (chunk.isNull()) return new Array<Entity>();

		// var local = w.toChunkLocal();
		// var ids = chunk.getEntityIdsAt(local.x, local.y);
		// return ids.map((id: String) -> this.loop.ecs.registry.getEntity(id));
		return [];
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
