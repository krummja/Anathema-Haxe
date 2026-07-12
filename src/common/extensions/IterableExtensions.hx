package common.extensions;

class IterableExtensions {
	public static function max<T>(it: Iterable<T>, fn: (value: T) -> Float): T {
		var cur: Null<T> = null;
		var curWeight = Math.NEGATIVE_INFINITY;

		for (value in it) {
			var weight = fn(value);
			if (cur == null || weight > curWeight) {
				curWeight = weight;
				cur = value;
			}
		}

		return cur;
	}

	public static function min<T>(it: Iterable<T>, fn: (value: T) -> Float): T {
		var cur = null;
		var curWeight = Math.POSITIVE_INFINITY;

		for (value in it) {
			var weight = fn(value);
			if (cur == null || weight < curWeight) {
				curWeight = weight;
				cur = value;
			}
		}

		return cur;
	}

	public static overload extern inline function each<A>(it: Iterable<A>, fn: (item: A, idx: Int) -> Void) {
		var i = 0;
		for (x in it) {
			fn(x, i++);
		}
	}

	public static overload extern inline function each<A>(it: Iterable<A>, fn: (item: A) -> Void) {
		for (x in it) {
			fn(x);
		}
	}

	public static inline function filter<A>(it: Iterable<A>, fn: (item: A) -> Bool) {
		return Lambda.filter(it, fn);
	}

	public static inline function first<T>(it: Iterable<T>): T {
		return it.iterator().next();
	}

	public static inline function fold<A, B>(it: Iterable<A>, fn: (item: A, result: B) -> B, first: B): B {
		return Lambda.fold(it, fn, first);
	}

	public static inline function foldi<A, B>(it: Iterable<A>, fn: (item: A, result: B, idx: Int) -> B, first: B): B {
		return Lambda.foldi(it, fn, first);
	}

	public static inline function sum<T>(it: Iterable<T>, fn: (value: T) -> Float): Float {
		return it.fold((it, res) -> fn(it) + res, 0);
	}

	public static inline function map<A, B>(it: Iterable<A>, fn: (item: A) -> B): Array<B> {
		return Lambda.map(it, fn);
	}

	public static inline function filterMap<A, B>(it: Iterable<A>, fn: (item: A) -> {value: B, filter: Bool}): Array<B> {
		return [
			for (x in it) {
				var r = fn(x);
				if (r.filter) {
					r.value;
				}
			}
		];
	}

	public static inline function flatten<A>(it: Iterable<Iterable<A>>): Array<A> {
		return Lambda.flatten(it);
	}

	public static inline function intersects<T>(it: Iterable<T>, other: Iterable<T>): Bool {
		return it.exists((v) -> other.has(v));
	}

	public static inline function has<T>(it: Iterable<T>, value: T): Bool {
		return Lambda.has(it, value);
	}

	public static inline function exists<T>(it: Iterable<T>, fn: (value: T) -> Bool): Bool {
		return Lambda.exists(it, fn);
	}

	public static inline function find<T>(it: Iterable<T>, fn: (value: T) -> Bool): T {
		return Lambda.find(it, fn);
	}
}
