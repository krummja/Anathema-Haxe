package domain.terrain;

import engine.BiomeType;
import engine.Biome;

class Biomes {
	public static var biomes: Array<Biome>;
	public static var BIOME_PRAIRIE: Biome;

	public function new() {}

	public function initialize(seed: Int) {
		BIOME_PRAIRIE = new PrairieBiome(seed + 1);

		biomes = [
			BIOME_PRAIRIE,
		];
	}

	public static function get(type: BiomeType): Biome {
		return switch type {
			case PRAIRIE: BIOME_PRAIRIE;
		}
	}
}
