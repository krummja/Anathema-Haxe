package domain.terrain;

import domain.terrain.TerrainType;
import domain.terrain.BiomeType;
import data.TileKey;


typedef Cell = {
    idx: Int,
    terrainType: TerrainType,
    biomeType: BiomeType,
    tileKey: TileKey,
    primary: Int,
    secondary: Int,
    background: Int,
}
