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
}
