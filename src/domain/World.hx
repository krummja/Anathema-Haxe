package domain;

import hxd.Rand;
import ecs.Entity;
import common.algorithm.Distance;
import common.struct.Size;
import common.struct.Rect;
import common.struct.Cardinal;
import common.struct.IntPoint;
import common.struct.Coordinate;
import domain.PlayerManager;
import domain.SystemManager;
import domain.terrain.MapData;
import domain.components.*;
import domain.prefabs.*;
import engine.*;

class World {
	public var loop(get, null): MainLoop;
	public var player(default, null): PlayerManager;
	public var behavior(default, null): BehaviorManager;
	public var chunks(default, null): ChunkManager;
	public var factions(default, null): FactionManager;
	public var zones(default, null): ZoneManager;

	public var zoneCountX(default, null): Int = 1;
	public var zoneCountY(default, null): Int = 1;
	public var zoneWidth(default, null): Int = 80;
	public var zoneHeight(default, null): Int = 50;

	public var chunkSubdivision(default, never): Int = 2;
	public var chunkWidth(get, never): Int;
	public var chunkHeight(get, never): Int;
	public var chunkCountX(get, never): Int;
	public var chunkCountY(get, never): Int;

	public var worldWidth(get, null): Int;
	public var worldHeight(get, null): Int;

	public var systems(default, null): SystemManager;
	public var clock(default, null): Clock;
	public var started(get, null): Bool = false;
	public var spawner(default, null): Spawner;
	public var map(default, null): MapData;

	public var timeStopped: Bool = false;

	public var rand: Rand;
	public var seed: Int = 2;

	private var visible: Array<Coordinate>;

	public function new() {
		this.systems = new SystemManager();
		this.clock = new Clock();
		this.player = new PlayerManager(this);
		this.behavior = new BehaviorManager();
		this.chunks = new ChunkManager();
		this.factions = new FactionManager();
		this.zones = new ZoneManager();
		this.spawner = new Spawner();

		this.map = new MapData();
	}

	public function initialize(): Void {
		this.rand = new Rand(seed);
		this.visible = [];

		this.factions.initialize();
		this.spawner.initialize();
		this.zones.initialize();
		this.chunks.initialize();
		this.map.initialize();
		this.player.initialize();
		this.systems.initialize();
		this.map.initialize();
	}

	public function start(seed: Int): Void {
		var pos = new Coordinate((worldWidth / 2).floor(), (worldHeight / 2).floor(), WORLD);
		chunks.loadChunks(pos.toChunkId());
		chunks.loadChunk(pos.toChunkId());

		this.player.create(pos);

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

		var localX = pos.x % chunkWidth;
		var localY = pos.y % chunkHeight;
		var ids = chunk.getEntityIdsAt(localX, localY);

		return ids.map((id: String) -> loop.registry.getEntity(id));
	}

	public overload extern inline function getEntitiesAt(pos: Coordinate): Array<Entity> {
		return getEntitiesAt(pos.toWorld().toIntPoint());
	}

	public function getEntitiesInRect(worldPos: IntPoint, width: Int, height: Int): Array<Entity> {
		var entities: Array<Entity> = [];

		for (x in worldPos.x...(worldPos.x + width)) {
			for (y in worldPos.y...(worldPos.y + height)) {
				entities = entities.concat(getEntitiesAt(new IntPoint(x, y)));
			}
		}

		return entities;
	}

	public function getEntitiesInRange(worldPos: IntPoint, range: Int): Array<Entity> {
		var diameter = (range * 2) + 1;
		var topLeft = worldPos.sub(new IntPoint(range, range));
		var result = getEntitiesInRect(topLeft, diameter, diameter);
		return result;
	}

	public function getEntityDistances(worldPos: IntPoint): Array<{id: String, d: Int}> {
		var distances = [];

		for (entity in loop.registry.entities) {
			var distance = Distance.Manhattan(worldPos, entity.pos.toIntPoint());
			if (distance == 0) {
				continue;
			}
			distances.push({id: entity.id, d: distance});
		}

		return distances;
	}

	public function getNeighborEntities(pos: IntPoint): Array<Array<Entity>> {
		return [
			getEntitiesAt(pos.add(Cardinal.NORTH_WEST.toOffset())),
			getEntitiesAt(pos.add(Cardinal.NORTH.toOffset())),
			getEntitiesAt(pos.add(Cardinal.NORTH_EAST.toOffset())),
			getEntitiesAt(pos.add(Cardinal.WEST.toOffset())),
			getEntitiesAt(pos.add(Cardinal.EAST.toOffset())),
			getEntitiesAt(pos.add(Cardinal.SOUTH_WEST.toOffset())),
			getEntitiesAt(pos.add(Cardinal.SOUTH.toOffset())),
			getEntitiesAt(pos.add(Cardinal.SOUTH_EAST.toOffset())),
		];
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

	public function clearVisible() {
		for (value in visible) {
			var c = value.toChunk();
			var chunk = chunks.getChunk(c.x, c.y);

			if (chunk == null || !chunk.isLoaded) {
				continue;
			}

			var local = value.toChunkLocal().toIntPoint();

			chunk.setExplore(local, true, false);
			for (entity in getEntitiesAt(value.toWorld().toIntPoint())) {
				if (entity.has(Visible)) {
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

			// Set explored tiles in chunk
			chunk.setExplore(local, true, true);

			// Get tile light data
			var light = systems.lights.getTileLight(pos.toIntPoint());

			// Apply visibility and exploration states to entities in the chunk
			for (entity in getEntitiesAt(pos.toWorld().toIntPoint())) {
				if (!entity.has(Visible)) {
					entity.add(new Visible());
				}

				if (!entity.has(Explored)) {
					entity.add(new Explored());
				}

				if (light.intensity > 0 && entity.has(Sprite) && entity.has(Explored)) {
					var sprite = entity.get(Sprite);
					sprite.shader.isLit = 1;
					sprite.shader.lightColor = light.color.toHxdColor().toVector();
					sprite.shader.lightIntensity = light.intensity;
				}
			}
		}

		visible.push(pos);
	}

	public function isExplored(coord: Coordinate): Bool {
		var c = coord.toChunk();
		var chunk = chunks.getChunk(c.x, c.y);
		if (chunk == null || !chunk.isLoaded) {
			return false;
		}

		var local = coord.toChunkLocal().toIntPoint();
		return chunk.isExplored(local);
	}

	public function isVisible(coord: Coordinate): Bool {
		return Lambda.exists(visible, (v) -> v.toWorld().equals(coord.toWorld().floor()));
	}

	public inline function isOutOfBounds(pos: IntPoint): Bool {
		return pos.x < 0 || pos.y < 0 || pos.x > worldWidth - 1 || pos.y > worldHeight - 1;
	}

	private function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}

	private function get_worldWidth(): Int {
		return this.chunkCountX * this.chunkWidth;
	}

	private function get_worldHeight(): Int {
		return this.chunkCountY * this.chunkHeight;
	}

	private function get_chunkCountX(): Int {
		return this.zoneCountX * this.chunkSubdivision;
	}

	private function get_chunkCountY(): Int {
		return this.zoneCountY * this.chunkSubdivision;
	}

	private function get_chunkWidth(): Int {
		return Math.ceil(this.zoneWidth / this.chunkSubdivision);
	}

	private function get_chunkHeight(): Int {
		return Math.ceil(this.zoneHeight / this.chunkSubdivision);
	}

	private function get_started(): Bool {
		return started;
	}
}
