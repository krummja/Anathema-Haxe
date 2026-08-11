package engine;

import common.struct.Grid;
import common.struct.IntPoint;
import domain.terrain.Cell;
import h2d.Bitmap;
import shaders.SpriteShader;

/**
 * Owns the actual Heaps rendering objects for a Zone's tilemap: one Bitmap
 * per cell plus the h2d.Object they're parented under. Zone delegates its
 * tile-rendering concerns here instead of constructing/owning h2d scene
 * objects itself.
 */
class ZoneView {
	private var bitmaps: Grid<Bitmap>;
	private var tiles: h2d.Object;
	private var width: Int;
	private var height: Int;

	public function new(width: Int, height: Int) {
		this.width = width;
		this.height = height;
	}

	public function load(): Void {
		this.bitmaps = new Grid(width, height);
		this.tiles = new h2d.Object();
	}

	public function unload(): Void {
		tiles.remove();
		tiles.removeChildren();
		bitmaps.clear();

		bitmaps = null;
		tiles = null;
	}

	public function build(cells: Grid<Cell>): Void {
		for (t in bitmaps) {
			var bm = createTileBitmap(cells.get(t.x, t.y));
			bm.x = t.x * MainLoop.getInstance().UNIT_X;
			bm.y = t.y * MainLoop.getInstance().UNIT_Y;
			tiles.addChildAt(bm, t.idx);
			bitmaps.set(t.x, t.y, bm);
		}
	}

	public function place(worldPixelX: Float, worldPixelY: Float): Void {
		MainLoop.getInstance().render(BACKGROUND, tiles);
		tiles.x = worldPixelX;
		tiles.y = worldPixelY;
	}

	public function setExplore(pos: IntPoint, isExplored: Bool, isVisible: Bool): Void {
		var bm = bitmaps.get(pos.x, pos.y);

		if (bm == null) {
			return;
		}

		var shader = bm.getShader(SpriteShader);

		if (isExplored) {
			bm.visible = true;
			shader.setShrouded(!isVisible);
		} else {
			shader.setShrouded(true);
			bm.visible = false;
		}
	}

	public function getShader(pos: IntPoint): SpriteShader {
		var bm = bitmaps.get(pos.x, pos.y);
		return bm == null ? null : bm.getShader(SpriteShader);
	}

	private function createTileBitmap(cell: Cell): Bitmap {
		var bm = new Bitmap();
		var shader = new SpriteShader(cell.primary, cell.secondary);

		if (cell.tileKey != null) {
			bm.tile = TileResources.get(cell.tileKey);
		}

		bm.addShader(shader);
		bm.visible = false;

		return bm;
	}
}
