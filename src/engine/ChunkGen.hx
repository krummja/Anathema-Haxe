package engine;

import hxd.Rand;

class ChunkGen {
	private var seed(get, null): Int;
	private var world(get, null): domain.World;

	public function new() {}

	public function generate(chunk: Chunk) {
		var r = new Rand(seed + chunk.chunkId);
		chunk.cells.fillFn((idx) -> generateCell(r, chunk, idx));
	}

	public function generateCell(r: Rand, chunk: Chunk, idx: Int) {
		var cell: Cell = {
			idx: idx,
			terrain: TERRAIN_GRASS,
			tileKey: TK_GRASS_01,
			primary: MainLoop.getInstance().palette.getColor(C_GREEN_3),
			secondary: 0x000000,
			background: 0x000000,
		};

		return cell;
	}

	private function get_seed(): Int {
		return engine.MainLoop.getInstance().world.seed;
	}

	private function get_world(): domain.World {
		return engine.MainLoop.getInstance().world;
	}
}
