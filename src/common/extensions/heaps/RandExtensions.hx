package common.extensions.heaps;

class RandExtensions {
	public static function integer<T>(r: hxd.Rand, min: Int, max: Int): Int {
		return Math.floor(min + (r.rand() * (max - min)));
	}

	public static function float<T>(r: hxd.Rand, min: Float, max: Float): Float {
		return min + (r.rand() * (max - min)).floor();
	}

	public static function bool<T>(r: hxd.Rand, chance: Float = 0.5): Bool {
		return r.rand() < chance;
	}

	public static function pick<T>(r: hxd.Rand, array: Array<T>): T {
		return array[r.random(array.length)];
	}

	public static function roll(r: hxd.Rand, faces: Int, mod: Int = 0): Int {
		return r.integer(1, faces + 1) + mod;
	}
}
