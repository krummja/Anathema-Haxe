package common.struct;

import common.struct.Grid.GridItem;
import data.save.GridSave;
import common.struct.Grid.GridIterator;

@:generic
class GridMap<T> {
	private var hash: Map<String, Int>;
	private var grid: Grid<Array<T>>;

	public var width(default, null): Int;
	public var height(default, null): Int;
	public var size(get, null): Int;

	public function new(width: Int = 128, height: Int = 128) {
		this.grid = new Grid(width, height);
		this.grid.fillFn((idx: Int) -> new Array());
		this.hash = new Map();
	}

	public function get(x: Int, y: Int): Array<T> {
		var res = this.grid.get(x, y);
		if (res == null) return new Array<T>();
		return res.copy();
	}

	public function set(x: Int, y: Int, value: T) {
		var idx = idx(x, y);
		setIdx(idx, value);
	}

	public function getIdx(id: T): Null<Int> {
		var idx = hash.get(Std.string(id));
		return idx;
	}

	public function setIdx(idx: Int, value: T): Void {
		remove(value);
		grid.getAt(idx).push(value);
		hash.set(Std.string(value), idx);
	}

	public function remove(value: T): Bool {
		if (!has(value)) {
			return false;
		}

		var idx = getIdx(value);
		hash.remove(Std.string(value));
		grid.getAt(idx).remove(value);
		return true;
	}

	public function clear(): Void {
		grid.clear();
		hash.clear();
	}

	public function has(value: T): Bool {
		return this.hash.exists(Std.string(value));
	}

	public inline function idx(x: Int, y: Int): Int {
		return this.grid.idx(x, y);
	}

	public function save<V>(fn: (Array<T>) -> V): GridSave<V> {
		return {
			width: width,
			height: height,
			data: grid.map((item: GridItem<Array<T>>) -> fn(item.value)),
		};
	}

	public function load<V>(save: GridSave<V>, fn: (V) -> Array<T>) {
		width = save.width;
		height = save.height;
		for (i => d in save.data) {
			var values = fn(d);
			for (v in values) {
				setIdx(i, v);
			}
		}
	}

	public function iterator(): GridIterator<Array<T>> {
		return new GridIterator(grid);
	}

	private function get_size(): Int {
		return this.width * this.height;
	}
}
