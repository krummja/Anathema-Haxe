package engine;

import common.struct.Coordinate;
import common.struct.Grid;
import data.SpawnableType;
import domain.prefabs.Spawner;
import hxd.BitmapData;

class Template {
	public var width(default, null): Int;
	public var height(default, null): Int;
	public var metaGrid(default, null): Grid<String>;
	public var tileGrid(default, null): Grid<SpawnableType>;

	private var bm: BitmapData;

	public function new(bm: BitmapData) {
		this.bm = bm;
		width = bm.width;
		height = bm.height;
		metaGrid = new Grid(width, height);
		tileGrid = new Grid(width, height);

		init();
	}

	public function paint(mapping: Map<String, SpawnableType>) {
		for (x in 0...width) {
			for (y in 0...height) {
				var meta = metaGrid.get(x, y);
				var tileVal = mapping[meta];
				tileGrid.set(x, y, tileVal);
			}
		}
	}

	public function materialize(pos: Coordinate) {
		for (tile in tileGrid) {
			if (tile.value == FLOOR) {
				continue;
			}

			var tilePos = pos.add(tile.pos.asWorld());
			Spawner.spawn(tile.value, tilePos);
		}
	}

	private function init() {
		for (x in 0...width) {
			for (y in 0...height) {
				var px = bm.getPixel(x, y);
				var color = px.toHxdColor();
				metaGrid.set(x, y, px.toHxdColor().toString());
			}
		}
	}
}

class TemplateResources {
	public static var templates: Map<TemplateKey, Template> = [];

	public static function get(key: TemplateKey): Template {
		var template = templates.get(key);
		return template;
	}

	public static function init() {
		loadTemplate(Test);
	}

	private static function loadTemplate(key: TemplateKey) {
		var templateName = Std.string(key).toLowerCase();
		var templateRes = hxd.Res.loader.load('templates/${templateName}.png');
		var bm = templateRes.toImage().toBitmap();
		templates.set(key, new Template(bm));
	}
}
