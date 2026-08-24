package common.extensions;

class ArrayExtensions {
	@:generic
	public static function findRemove<T>(a: Array<T>, fn: (a: T) -> Bool): Bool {
		var idx = a.findIdx(fn);
		if (idx >= 0) {
			a.splice(idx, 1);
			return true;
		}
		return false;
	}

	@:generic
	public static function fillFn<T>(a: Array<T>, fn: (Int) -> T): Void {
		for (idx in 0...a.length) {
			a[idx] = fn(idx);
		}
	}

	@:generic
	public static function fill<T>(a: Array<T>, value: T): Void {
		for (idx in 0...a.length) {
			a[idx] = value;
		}
	}
}
