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

		var thickSheet = hxd.Res.tiles.walls_thick_16_16;
		var thick = divideTilesheet(thickSheet.toTile(), 12, 4);
		tiles.set(WALL_THICK_0_0, thick[0][0]);
		tiles.set(WALL_THICK_0_1, thick[0][1]);
		tiles.set(WALL_THICK_0_2, thick[0][2]);
		tiles.set(WALL_THICK_0_3, thick[0][3]);
		tiles.set(WALL_THICK_0_4, thick[0][4]);
		tiles.set(WALL_THICK_0_5, thick[0][5]);
		tiles.set(WALL_THICK_0_6, thick[0][6]);
		tiles.set(WALL_THICK_0_7, thick[0][7]);
		tiles.set(WALL_THICK_0_8, thick[0][8]);
		tiles.set(WALL_THICK_0_9, thick[0][9]);
		tiles.set(WALL_THICK_0_10, thick[0][10]);
		tiles.set(WALL_THICK_0_11, thick[0][11]);
		tiles.set(WALL_THICK_1_0, thick[1][0]);
		tiles.set(WALL_THICK_1_1, thick[1][1]);
		tiles.set(WALL_THICK_1_2, thick[1][2]);
		tiles.set(WALL_THICK_1_3, thick[1][3]);
		tiles.set(WALL_THICK_1_4, thick[1][4]);
		tiles.set(WALL_THICK_1_5, thick[1][5]);
		tiles.set(WALL_THICK_1_6, thick[1][6]);
		tiles.set(WALL_THICK_1_7, thick[1][7]);
		tiles.set(WALL_THICK_1_8, thick[1][8]);
		tiles.set(WALL_THICK_1_9, thick[1][9]);
		tiles.set(WALL_THICK_1_10, thick[1][10]);
		tiles.set(WALL_THICK_1_11, thick[1][11]);
		tiles.set(WALL_THICK_2_0, thick[2][0]);
		tiles.set(WALL_THICK_2_1, thick[2][1]);
		tiles.set(WALL_THICK_2_2, thick[2][2]);
		tiles.set(WALL_THICK_2_3, thick[2][3]);
		tiles.set(WALL_THICK_2_4, thick[2][4]);
		tiles.set(WALL_THICK_2_5, thick[2][5]);
		tiles.set(WALL_THICK_2_6, thick[2][6]);
		tiles.set(WALL_THICK_2_7, thick[2][7]);
		tiles.set(WALL_THICK_2_8, thick[2][8]);
		tiles.set(WALL_THICK_2_9, thick[2][9]);
		tiles.set(WALL_THICK_2_10, thick[2][10]);
		tiles.set(WALL_THICK_2_11, thick[2][11]);
		tiles.set(WALL_THICK_3_0, thick[3][0]);
		tiles.set(WALL_THICK_3_1, thick[3][1]);
		tiles.set(WALL_THICK_3_2, thick[3][2]);
		tiles.set(WALL_THICK_3_3, thick[3][3]);
		tiles.set(WALL_THICK_3_4, thick[3][4]);
		tiles.set(WALL_THICK_3_5, thick[3][5]);
		tiles.set(WALL_THICK_3_6, thick[3][6]);
		tiles.set(WALL_THICK_3_7, thick[3][7]);
		tiles.set(WALL_THICK_3_8, thick[3][8]);
		tiles.set(WALL_THICK_3_9, thick[3][9]);
		tiles.set(WALL_THICK_3_10, thick[3][10]);
		tiles.set(WALL_THICK_3_11, thick[3][11]);

		var wallsSheet = hxd.Res.tiles.walls_16_16;
		var walls = divideTilesheet(wallsSheet.toTile(), 4, 4);
		tiles.set(WALL_0, walls[0][0]);
		tiles.set(WALL_1, walls[0][1]);
		tiles.set(WALL_2, walls[0][2]);
		tiles.set(WALL_3, walls[0][3]);
		tiles.set(WALL_4, walls[1][0]);
		tiles.set(WALL_5, walls[1][1]);
		tiles.set(WALL_6, walls[1][2]);
		tiles.set(WALL_7, walls[1][3]);
		tiles.set(WALL_8, walls[2][0]);
		tiles.set(WALL_9, walls[2][1]);
		tiles.set(WALL_10, walls[2][2]);
		tiles.set(WALL_11, walls[2][3]);
		tiles.set(WALL_12, walls[3][0]);
		tiles.set(WALL_13, walls[3][1]);
		tiles.set(WALL_14, walls[3][2]);
		tiles.set(WALL_15, walls[3][3]);
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
