package engine;

import engine.ColorKey;

typedef Cell = {
	idx: Int,
	terrain: TerrainType,
	tileKey: TileKey,
	primary: ColorKey,
	secondary: ColorKey,
	background: ColorKey,
};
