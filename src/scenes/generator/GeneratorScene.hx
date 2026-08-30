package scenes.generator;

import common.struct.Cardinal;
import common.struct.Grid;
import common.struct.IntPoint;
import common.struct.Rect;
import common.struct.Size;
import engine.KeyCode;
import engine.Scene;
import h2d.Bitmap;
import h2d.Tile;
import hxd.PixelFormat;
import hxd.Pixels;

typedef GridCell = {
	var color: Int;
}

typedef Connection = {
	var side: Cardinal;
	var position: IntPoint;
}

typedef Element = {
	var cells: Grid<GridCell>;
	var connections: Array<Connection>;
}

class GeneratorScene extends Scene {
	private var bm: Bitmap;
	private var workspace: Grid<GridCell>;
	private var elements: Array<Element>;

	private var width: Int;
	private var height: Int;

	public function new() {
		workspace = new Grid();
		elements = [];

		this.width = 128;
		this.height = 128;
		bm = new Bitmap();

		loop.render(HUD, bm);
	}

	private function initRootElement(): Element {
		var element: Element = {
			cells: new Grid(17, 17),
			connections: [],
		};

		var b = new Rect({x: 0, y: 0}, new Size(16, 16));

		var cx = (element.cells.width / 2).floor();
		var cy = (element.cells.height / 2).floor();
		var r = Rect.centeredAt({w: 2, h: 2}, new IntPoint(cx, cy));

		for (p in b.iterPoints()) {
			element.cells.set(p.x, p.y, {color: 0xff660066});
		}

		for (p in r.iterPoints()) {
			element.cells.set(p.x, p.y, {color: 0xffffffff});
		}

		return element;
	}

	private override function onKeyDown(key: KeyCode) {
		if (key == KEY_SPACE) {
			var rootElem = initRootElement();
			var pixels = Pixels.alloc(width, height, ARGB);

			for (p in rootElem.cells) {
				if (p.value != null) {
					pixels.setPixel(p.x, p.y, p.value.color);
				}
			}

			var tile = Tile.fromPixels(pixels);
			bm.tile = tile;
			bm.setScale(5.0);
		}
	}
}
