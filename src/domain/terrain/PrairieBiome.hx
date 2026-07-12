package domain.terrain;

import domain.prefabs.Spawner;
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

		if (h < 0.4) {
			return TK_DIRT_01;
		}

		if (h < 0.42) {
			return TK_DIRT_02;
		}

		if (h < 0.44) {
			return TK_DIRT_03;
		}

		if (h < 0.46) {
			return TK_DIRT_04;
		}

		if (h < 0.48) {
			return TK_DIRT_05;
		}

		if (h < 0.75) {
			return TK_GRASS_01;
		}

		return TK_GRASS_02;
	}

	public override function setCellData(pos: IntPoint, cell: Cell) {
		cell.tileKey = getBackgroundTileKey(pos);
		cell.terrain = TERRAIN_GRASS;

		var c = r.pick([C_GREEN_1, C_GREEN_2, C_GREEN_3]);
		var d = r.pick([C_YELLOW_0, C_YELLOW_1, C_YELLOW_2]);

		if ([TK_GRASS_01, TK_GRASS_02].contains(cell.tileKey)) {
			cell.primary = c;
		} else {
			cell.primary = d;
		}

		cell.background = C_GREEN_0;
	}

	public override function spawnEntity(pos: IntPoint, cell: Cell) {
		if (cell.terrain == TERRAIN_GRASS) {
			var h = perlin.get(pos, 6);

			if (h > 0.65) {
				Spawner.spawn(TALL_GRASS, pos.asWorld());
			}
		}
	}
}
