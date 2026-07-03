package engine;

import shaders.SpriteShader;
import h2d.Bitmap;
import ecs.Entity;
import domain.components.Position;
import common.struct.IntPoint;
import common.struct.Grid;
import common.struct.GridMap;

class Chunk {
	public var entities(default, null): GridMap<String>;
	public var exploration(default, null): Grid<Null<Bool>>;
	public var bitmaps(default, null): Grid<Bitmap>;
	public var isLoaded(default, null): Bool;
	public var cells(default, null): Grid<Cell>;

	public var size(default, null): Int;
	public var chunkId(default, null): Int;
	public var zoneId(get, never): Int;
	public var zone(get, never): Zone;

	public var chunkPos(get, never): IntPoint;
	public var worldPos(get, never): IntPoint;

	private var tiles: h2d.Object;

	public function new(chunkId: Int, size: Int) {
		this.chunkId = chunkId;
		this.size = size;
		this.cells = new Grid(size, size);
	}

	public function load() {
		if (isLoaded) {
			return;
		}

		isLoaded = true;

		this.entities = new GridMap(size, size);
		this.bitmaps = new Grid(size, size);
		this.exploration = new Grid(size, size);
		this.cells = new Grid(size, size);
		this.tiles = new h2d.Object();

		exploration.fill(false);
		MainLoop.getInstance().world.chunks.chunkGen.generate(this);

		buildTiles();

		MainLoop.getInstance().render(BACKGROUND, tiles);
		var pix = worldPos.asWorld().toPixel();
		tiles.x = pix.x;
		tiles.y = pix.y;
	}

	public function unload() {
		if (!isLoaded) {
			trace('Cannot unload an already unloaded chunk');
			return;
		}

		tiles.remove();
		tiles.removeChildren();
		bitmaps.clear();

		exploration = null;
		entities = null;
		bitmaps = null;
		tiles = null;
		cells = null;

		isLoaded = false;
	}

	public function buildTiles(): Void {
		for (t in bitmaps) {
			var bm = getGroundBitmap(t.pos);
			bm.x = t.x * MainLoop.getInstance().UNIT_X;
			bm.y = t.y * MainLoop.getInstance().UNIT_Y;
			tiles.addChildAt(bm, t.idx);
			bitmaps.set(t.x, t.y, bm);
		}
	}

	public function getEntityIdsAt(x: Float, y: Float): Array<String> {
		if (!isLoaded) {
			return [];
		}

		return this.entities.get(Math.floor(x), Math.floor(y));
	}

	public function setExplore(pos: IntPoint, isExplored: Bool, isVisible: Bool) {
		if (!isLoaded) {
			trace('Warning: Loading chunk on demand');
			MainLoop.getInstance().world.chunks.loadChunk(chunkId);
			return;
		}

		var idx = exploration.idx(pos.x, pos.y);
		if (idx < 0) {
			return;
		}

		exploration.setIdx(idx, isExplored);

		var bm = bitmaps.get(pos.x, pos.y);

		if (bm == null) {
			return;
		}

		var shader = bm.getShader(SpriteShader);

		if (isExplored) {
			bm.visible = true;
			if (!isVisible) {
				shader.setShrouded(true);
			} else {
				shader.setShrouded(false);
			}
		} else {
			shader.setShrouded(true);
			bm.visible = false;
		}
	}

	public function setEntityPosition(entity: Entity): Void {
		if (!isLoaded) {
			return;
		}

		var local = entity.pos.toChunkLocal().toWorld();
		entities.set(Math.floor(local.x), Math.floor(local.y), entity.id);
	}

	public function removeEntity(entity: Entity): Void {
		if (!isLoaded) {
			return;
		}
		entities.remove(entity.id);
	}

	public function getCell(localX: Int, localY: Int): Cell {
		if (!isLoaded) {
			return null;
		}

		return cells.get(localX, localY);
	}

	private function getGroundBitmap(pos: IntPoint): Bitmap {
		var cell = getCell(pos.x, pos.y);

		var tileKey = cell.tileKey;
		var primary = cell.primary;
		var secondary = cell.secondary;
		var background = cell.background;

		var bm = new h2d.Bitmap();
		var shader = new SpriteShader(primary, secondary);

		if (tileKey != null) {
			bm.tile = TileResources.get(tileKey);
		}

		bm.addShader(shader);
		bm.visible = true;

		return bm;
	}

	private function get_zoneId(): Int {
		var pos = chunkPos.divide(MainLoop.getInstance().world.chunksPerZone).floor();
		return MainLoop.getInstance().world.zones.getZoneId(pos);
	}

	private function get_zone(): Zone {
		return MainLoop.getInstance().world.zones.getZoneById(zoneId);
	}

	private function get_chunkPos(): IntPoint {
		return MainLoop.getInstance().world.chunks.getChunkPos(chunkId);
	}

	private function get_worldPos(): IntPoint {
		return chunkPos.multiply(size);
	}
}
