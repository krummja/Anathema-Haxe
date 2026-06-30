package common.extensions;

class NullExtensions {
	public static inline function or<T>(nullable: Null<T>, def: T): T {
		return nullable == null ? def : nullable;
	}
}
