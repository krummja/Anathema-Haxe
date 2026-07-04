package domain.terrain;

import hxd.Rand;
import engine.MainLoop;

class MapData {
	private var world(get, never): World;
	private var seed(get, never): Int;
	private var r: Rand;
	private var biomes: Biomes;

	public function new() {
		biomes = new Biomes();
	}

	public function initialize() {
		biomes.initialize(seed);
	}

	private function get_world(): World {
		return MainLoop.getInstance().world;
	}

	private function get_seed(): Int {
		return world.seed;
	}
}
