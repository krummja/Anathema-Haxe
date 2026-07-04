package engine;

import engine.BiomeType;
import engine.ColorKey;

typedef Cell = {
	idx: Int,
	terrain: TerrainType,
	biomeKey: BiomeType,
	tileKey: TileKey,
	primary: ColorKey,
	secondary: ColorKey,
	background: ColorKey,
}
