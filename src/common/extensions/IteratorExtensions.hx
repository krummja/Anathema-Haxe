package common.extensions;

class IteratorExtensions {
	@:generic
	public static function toArray<T>(it: Iterator<T>): Array<T> {
		return [for (item in it) item];
	}
}
