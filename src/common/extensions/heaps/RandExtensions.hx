package common.extensions.heaps;

class RandExtensions {
	public static function integer<T>(r: hxd.Rand, min: Int, max: Int): Int {
		return Math.floor(min + (r.rand() * (max - min)));
	}

	public static function pick<T>(r: hxd.Rand, array: Array<T>): T {
		return array[r.random(array.length)];
	}
}
