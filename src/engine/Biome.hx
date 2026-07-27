package engine;

import data.SpawnableType;
import common.struct.WeightedTable;
import common.rand.Perlin;
import common.struct.IntPoint;
import hxd.Rand;

class Biome {
	public var seed: Int;
	public var clearColor: Int;
	public var type(default, null): BiomeType;
	public var creatures: WeightedTable<SpawnableType>;

	private var r: Rand;
	private var perlin: Perlin;

	public function new(seed: Int, type: BiomeType, clearColor: Int = 0x191d31) {
		this.seed = seed;
		this.clearColor = clearColor;
		this.type = type;

		r = new Rand(seed);
		perlin = new Perlin(seed);

		creatures = setupCreatures();
	}

	public function setCellData(pos: IntPoint, cell: Cell) {
		cell.terrain = TERRAIN_GRASS;
		cell.tileKey = TK_GRASS_01;
		cell.primary = C_GREEN_1;
		cell.background = C_GREEN_3;
	}

	public function setupCreatures(): WeightedTable<SpawnableType> {
		var e = new WeightedTable<SpawnableType>();
		e.add(BAT, 1);
		return e;
	}

	public function spawnEntity(pos: IntPoint, cell: Cell) {}
}
