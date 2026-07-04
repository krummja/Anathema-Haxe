package common.rand;

import common.struct.IntPoint;

class Perlin {
	public var seed: Int = 0;

	private var perlin: hxd.Perlin;

	public function new(seed: Int = 0) {
		this.seed = seed;
		perlin = new hxd.Perlin();
		perlin.normalize = true;
	}

	public overload extern inline function get(x: Float, y: Float, scale: Float = 1.0, octaves: Int = 8) {
		var n = perlin.perlin(seed, x / scale, y / scale, octaves);
		return (n + 1) / 2;
	}

	public overload extern inline function get(p: IntPoint, scale: Float = 1.0, octaves: Int = 8) {
		var n = perlin.perlin(seed, p.x / scale, p.y / scale, octaves);
		return (n + 1) / 2;
	}
}
