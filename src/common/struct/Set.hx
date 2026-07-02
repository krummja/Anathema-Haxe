package common.struct;

import haxe.iterators.ArrayIterator;

@:generic
class Set<T> {
	public var items: Array<T>;
	public var isEmpty(get, never): Bool;
	public var length(get, never): Int;

	public function new() {
		items = new Array();
	}

	public function has(v: T): Bool {
		return Lambda.exists(items, x -> x == v);
	}

	public function add(v: T): Int {
		if (!has(v)) {
			items.push(v);
		}

		return length;
	}

	public function remove(v: T): Bool {
		return items.remove(v);
	}

	public function pop(): Null<T> {
		return isEmpty ? null : items.pop();
	}

	public function iterator(): ArrayIterator<T> {
		return items.iterator();
	}

	public function asArray() {
		return items;
	}

	private function get_isEmpty(): Bool {
		return items.length == 0;
	}

	private function get_length(): Int {
		return items.length;
	}
}

class SetTools {
	public static function fromIterables<T>(arrays: Array<Iterable<T>>): Set<T> {
		var _set = new Set<T>();

		for (arr in arrays) {
			for (elem in arr) {
				_set.add(elem);
			}
		}

		return _set;
	}
}
