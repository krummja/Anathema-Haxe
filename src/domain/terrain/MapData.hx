package domain.terrain;

import hxd.Rand;

class MapData {
	private var seed(get, never): Int;
	private var r: Rand;
	private var biomes: Biomes;

	public function new() {
		biomes = new Biomes();
	}

	public function initialize() {
		biomes.initialize(seed);
	}

	private function get_seed(): Int {
		return World.instance.seed;
	}
}
