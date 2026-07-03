package data;

import common.util.BitUtil;
import common.struct.Cardinal;
import common.struct.DataRegistry;
import engine.TileKey;

enum BitmaskStyle {
	BITMASK_STYLE_2D;
	BITMASK_STYLE_BASIC;
	BITMASK_STYLE_SIMPLE;
	BITMASK_STYLE_FULL;
}

typedef BitmaskData = {
	var style: BitmaskStyle;
	var tiles: Array<TileKey>;
	var invertUnexplored: Bool;
}

class Bitmasks {
	private static var registry: DataRegistry<BitmaskType, BitmaskData>;

	public static function init() {
		registry = new DataRegistry();

		registry.register(BITMASK_WALL, {
			style: BITMASK_STYLE_SIMPLE,
			invertUnexplored: false,
			tiles: [],
		});
	}

	public static function get(bitmaskType: BitmaskType) {
		return registry.get(bitmaskType);
	}

	public static function sumMask(fn: (x: Int, y: Int) -> Bool): Int {
		return Cardinal.values.foldi((direction, sum, idx) -> {
			var offset = direction.toOffset();
			var countCell = fn(offset.x, offset.y);
			return countCell ? sum + 2.pow(idx) : sum;
		}, 0);
	}

	public static function getTileIndex(style: BitmaskStyle, mask: Int) {
		if (style == BITMASK_STYLE_BASIC) {
			var below = BitUtil.hasBit(mask, 6);
			return below ? 0 : 1;
		}

		return -1;
	}

	public static function getTileKey(bitmaskType: BitmaskType, mask: Int) {
		var bm = get(bitmaskType);
		var idx = getTileIndex(bm.style, mask);
		if (idx >= 0 && idx < bm.tiles.length) {
			return bm.tiles[idx];
		}

		return TK_UNKNOWN;
	}
}
