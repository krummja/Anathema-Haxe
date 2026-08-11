package domain.terrain;

import engine.ColorKey;
import engine.TileKey;

typedef Cell = {
	idx: Int,
	terrain: TerrainType,
	biomeKey: BiomeType,
	tileKey: TileKey,
	primary: ColorKey,
	secondary: ColorKey,
	background: ColorKey,
}
