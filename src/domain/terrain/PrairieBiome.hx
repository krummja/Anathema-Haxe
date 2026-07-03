package domain.terrain;

import engine.Cell;
import common.struct.IntPoint;
import engine.Biome;
import engine.ColorKey;

class PrairieBiome extends Biome {
	public function new(seed: Int) {
		super(seed, PRAIRIE, 0x191d0a);
	}

	public override function setCellData(pos: IntPoint, cell: Cell) {
		cell.tileKey = TK_GRASS_01;
		cell.terrain = TERRAIN_GRASS;

		var c = r.pick([C_GREEN_1, C_GREEN_2, C_GREEN_3]);

		cell.primary = c;
		cell.background = C_GREEN_0;
	}
}
