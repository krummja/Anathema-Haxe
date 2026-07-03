package engine;

import h2d.Tile;

class TileResources {
	public static var tiles: Map<TileKey, Tile> = [];

	public static function get(key: TileKey): Tile {
		if (key == null) {
			return null;
		}

		var tile = tiles.get(key);

		if (tile == null) {
			return tiles.get(TK_UNKNOWN);
		}

		return tile;
	}

	public static function init() {
		var sheet = hxd.Res.tiles.kenny2_transparent;
		var t = divideTilesheet(sheet.toTile(), 49, 22);

		// @formatter:off
		tiles.set(TK_FOLIAGE_01, 		t[0][1]);
		tiles.set(TK_TILES_01, 			t[0][2]);
		tiles.set(TK_TILES_02, 			t[0][3]);
		tiles.set(TK_TILES_03, 			t[0][4]);
		tiles.set(TK_GRASS_01, 			t[0][5]);
		tiles.set(TK_FLOWERS_01, 		t[0][6]);
		tiles.set(TK_GRASS_02, 			t[0][7]);

		tiles.set(TK_TREE_01, 			t[1][0]);
		tiles.set(TK_TREE_02, 			t[1][1]);
		tiles.set(TK_TREE_03, 			t[1][2]);
		tiles.set(TK_TREE_04, 			t[1][3]);
		tiles.set(TK_TREE_05, 			t[1][4]);
		tiles.set(TK_TREE_06, 			t[1][5]);
		tiles.set(TK_CACTUS_01,			t[1][6]);
		tiles.set(TK_CACTUS_02, 		t[1][7]);

		tiles.set(TK_TALL_GRASS_01, 	t[2][0]);
		tiles.set(TK_PLANT_01, 			t[2][1]);
		tiles.set(TK_VINE_01, 			t[2][2]);
		tiles.set(TK_TREE_07, 			t[2][3]);
		tiles.set(TK_TREE_08, 			t[2][4]);
		tiles.set(TK_ROCKS_01, 			t[2][5]);
		tiles.set(TK_DEAD_TREE_01, 		t[2][6]);
		tiles.set(TK_PALM_01, 			t[2][7]);

		tiles.set(TK_PLAYER_01, 		t[0][25]);

		tiles.set(TK_BAT_01,			t[8][26]);
		// @formatter:on
		trace("TileResources initialized");
	}

	private static function divideTilesheet(tile: Tile, sizeX: Int, sizeY: Int): Array<Array<Tile>> {
		var tileW = Math.floor(tile.width / sizeX);
		var tileH = Math.floor(tile.height / sizeY);
		var tiles_out = new Array<Array<Tile>>();

		for (y in 0...sizeY) {
			var row = new Array<Tile>();
			for (x in 0...sizeX) {
				row.push(tile.sub(x * tileW, y * tileH, tileW, tileH));
			}

			tiles_out.push(row);
		}

		return tiles_out;
	}
}
