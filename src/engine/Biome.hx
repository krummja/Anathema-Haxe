package engine;

import common.struct.IntPoint;
import hxd.Rand;

class Biome {
	public var seed: Int;
	public var clearColor: Int;
	public var type(default, null): BiomeType;

	private var r: Rand;

	public function new(seed: Int, type: BiomeType, clearColor: Int = 0x191d31) {
		this.seed = seed;
		this.clearColor = clearColor;
		this.type = type;

		r = new Rand(seed);
	}

	public function setCellData(pos: IntPoint, cell: Cell) {
		cell.terrain = TERRAIN_GRASS;
		cell.tileKey = TK_GRASS_01;
		cell.primary = C_GREEN_1;
		cell.background = C_GREEN_3;
	}

	public function spawnEntity(pos: IntPoint, cell: Cell) {}
}
