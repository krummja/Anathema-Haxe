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

		if (h > 0.5) {
			return TK_GRASS_01;
		}

		return TK_GRASS_02;
	}

	public override function setCellData(pos: IntPoint, cell: Cell) {
		cell.tileKey = getBackgroundTileKey(pos);
		cell.terrain = TERRAIN_GRASS;

		var c = r.pick([C_GREEN_1, C_GREEN_2, C_GREEN_3]);

		cell.primary = c;
		cell.background = C_GREEN_0;
	}
}
