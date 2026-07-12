package engine;

import domain.terrain.Biomes;
import engine.BiomeType;
import hxd.Rand;

class ChunkGen {
	private var seed(get, null): Int;
	private var world(get, null): domain.World;

	public function new() {}

	public function generate(chunk: Chunk) {
		var r = new Rand(seed + chunk.chunkId);
		chunk.cells.fillFn((idx) -> generateCell(r, chunk, idx));

		for (cell in chunk.cells) {
			var worldPos = chunk.worldPos.add(cell.pos);

			var b = Biomes.get(cell.value.biomeKey);
			b.spawnEntity(worldPos, cell.value);
		}
	}

	public function generateCell(r: Rand, chunk: Chunk, idx: Int) {
		var pos = chunk.getCellCoord(idx);
		var biome = Biomes.get(PRAIRIE);

		var cell: Cell = {
			idx: idx,
			terrain: TERRAIN_GRASS,
			biomeKey: PRAIRIE,
			tileKey: TK_GRASS_01,
			primary: C_GREEN_3,
			secondary: C_BLACK,
			background: C_BLACK,
		};

		var worldPos = pos.add(chunk.worldPos);

		biome.setCellData(worldPos, cell);

		return cell;
	}

	private function get_seed(): Int {
		return engine.MainLoop.getInstance().world.seed;
	}

	private function get_world(): domain.World {
		return engine.MainLoop.getInstance().world;
	}
}
