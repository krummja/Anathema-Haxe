package domain.terrain;

import engine.TileKey;
import engine.Cell;
import common.struct.IntPoint;
import engine.Biome;
import engine.ColorKey;

class PrairieBiome extends Biome {
	public function new(seed: Int) {
		super(seed, PRAIRIE, 0x191d0a);
	}

	public function getBackgroundTileKey(pos: IntPoint): TileKey {
		var h = perlin.get(pos, 6);

		// if (h < 0.5) {
		// 	return TK_DIRT_01;
		// }

		// if (h < 0.55) {
		// 	return TK_DIRT_02;
		// }

		// if (h < 0.6) {
		// 	return TK_DIRT_03;
		// }

		// if (h < 0.65) {
		// 	return TK_DIRT_04;
		// }

		// if (h < 0.7) {
		// 	return TK_DIRT_05;
		// }

		if (h > 0.5) {
			return TK_GRASS_01;
		}

		return TK_GRASS_02;
	}

	public override function setCellData(pos: IntPoint, cell: Cell) {
		cell.tileKey = getBackgroundTileKey(pos);
		cell.terrain = TERRAIN_GRASS;

		var c = r.pick([C_GREEN_1, C_GREEN_2, C_GREEN_3]);
		// var d = r.pick([C_YELLOW_0, C_YELLOW_1, C_YELLOW_2]);

		cell.primary = c;
		// if ([TK_GRASS_01, TK_GRASS_02].contains(cell.tileKey)) {
		// } else {
		// 	cell.primary = d;
		// }

		cell.background = C_GREEN_0;
	}
}
