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
		var sheet = hxd.Res.tiles.Bisasam_24x24;
		var t = divideTilesheet(sheet.toTile(), 16, 16);

		tiles.set(TK_PLAYER, t[0][1]);
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
