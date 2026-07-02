package engine;

import events.EntitySpawnedEvent;
import echoes.Echoes;
import echoes.Entity;
import hxd.Rand;
import events.ConsumeEnergyEvent;
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
		this.systems.addSystem(ON_UPDATE, new ChunkSystem());
		this.systems.addSystem(ON_UPDATE, new LightSystem());
		this.systems.addSystem(ON_UPDATE, new VisionSystem());
		this.systems.addSystem(POST_UPDATE, new RenderSystem());
		this.systems.activateAll();
	}

	public function start(seed: Int): Void {
		this.seed = seed;
		this.rand = new Rand(seed);
		this.visible = new Array();

		var pos = new Coordinate(Math.floor(worldWidth / 2), Math.floor(worldHeight / 2), WORLD);
		this.chunks.loadChunks(pos.toChunkId());
		this.chunks.loadChunk(pos.toChunkId());

		this.player.create(new Coordinate(100, 100, WORLD));
		this.player.entity.fireEvent(new EntitySpawnedEvent());

		// var bat = spawner.spawn(BAT, new Coordinate(4, 4, WORLD));
		// bat.add(new Visible());

		// var bat2 = spawner.spawn(BAT, new Coordinate(-4, -3, WORLD));
		// bat2.add(new Explored());

		var wall = spawner.spawn(WALL, new Coordinate(100, 104, WORLD));
		wall.fireEvent(new EntitySpawnedEvent());

		var light = spawner.spawn(LIGHT, new Coordinate(101, 101, WORLD));
		light.fireEvent(new EntitySpawnedEvent());

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

	public function clearVisible() {
		for (value in visible) {
			var c = value.toChunk();
			var chunk = chunks.getChunk(c.x, c.y);
			if (chunk == null || !chunk.isLoaded) {
				continue;
			}

			var local = value.toChunkLocal().toIntPoint();

			for (entity in getEntitiesAt(value.toWorld().toIntPoint())) {
				if (entity.exists(Visible)) {
					entity.remove(Visible);
				}
			}
		}

		visible = [];
	}

	public function setVisible(pos: Coordinate) {
		var c = pos.toChunk();
		var chunk = chunks.getChunk(c.x, c.y);
		if (chunk != null) {
			var local = pos.toChunkLocal().toIntPoint();

			// TODO explored

			var light = systems.getSystem(ON_UPDATE, LightSystem).getTileLight(pos.toIntPoint());

			for (entity in getEntitiesAt(pos.toWorld().toIntPoint())) {
				if (!entity.exists(Visible)) {
					entity.add(new Visible());
				}

				if (light.intensity > 0) {
					var sprite = entity.get(Sprite);
					sprite.shader.isLit = 1;
					sprite.shader.lightColor = light.color.toHxdColor().toVector();
					sprite.shader.lightIntensity = light.intensity;
				}
			}
		}

		visible.push(pos);
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
