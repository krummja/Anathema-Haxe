package common.struct;

import data.save.GridSave;

@:generic
class Grid<T> {
	public var width(default, null): Int;
	public var height(default, null): Int;
	public var size(get, null): Int;

	public var data: Array<T>;

	public function new(width: Int = 128, height: Int = 128) {
		this.width = width;
		this.height = height;
		this.data = new Array();
	}

	public function fill(value: T): Void {
		for (idx in 0...this.size) {
			this.data[idx] = value;
		}
	}

	public function fillFn(fn: (Int) -> T): Void {
		for (idx in 0...this.size) {
			this.data[idx] = fn(idx);
		}
	}

	public inline function idx(x: Int, y: Int): Int {
		return y * this.width + x;
	}

	public inline function x(idx: Int): Int {
		return Math.floor(idx % width);
	}

	public inline function y(idx: Int): Int {
		return Math.floor(idx / width);
	}

	public function coord(idx: Int): IntPoint {
		return {
			x: this.x(idx),
			y: this.y(idx),
		};
	}

	public inline function getAt(idx: Int): Null<T> {
		return this.data[idx];
	}

	public function get(x: Int, y: Int): T {
		if (this.isOutOfBounds(x, y)) return null;
		var idx = this.idx(x, y);
		return this.data[idx];
	}

	public function set(x: Int, y: Int, value: T) {
		if (isOutOfBounds(x, y)) {
			throw 'Trying to set out-of-bounds grid coordinates (${x}, ${y}) to value ${value}';
		}

		var idx = idx(x, y);
		data[idx] = value;
	}

	public function setIdx(idx: Int, value: T) {
		if (isIdxOutOfBounds(idx)) {
			throw 'Trying to set out-of-bounds grid index (${idx}) to value ${value}';
		}

		data[idx] = value;
	}

	public function save<V>(fn: (T) -> V): GridSave<V> {
		return {
			width: width,
			height: height,
			data: data.map((d: T) -> fn(d)),
		};
	}

	public function load<V>(save: GridSave<V>, fn: (V) -> T) {
		width = save.width;
		height = save.height;
		data = save.data.map(fn);
	}

	public function clear(): Void {
		this.data = new Array();
	}

	public inline function isOutOfBounds(x: Int, y: Int): Bool {
		return this.isXOutOfBounds(x) || this.isYOutOfBounds(y);
	}

	public inline function isIdxOutOfBounds(idx: Int): Bool {
		return idx > size || idx < 0;
	}

	public inline function isXOutOfBounds(x: Int): Bool {
		return x < 0 || x >= this.width;
	}

	public inline function isYOutOfBounds(y: Int): Bool {
		return y < 0 || y >= this.height;
	}

	public function iterator(): GridIterator<T> {
		return new GridIterator(this);
	}

	private function get_size(): Int {
		return this.height * this.width;
	}
}

@:generic
typedef GridItem<T> = {
	var idx: Int;
	var x: Int;
	var y: Int;
	var pos: IntPoint;
	var value: T;
}

@:generic
class GridIterator<T> {
	var grid: Grid<T>;
	var i: Int;

	public inline function new(grid: Grid<T>) {
		this.grid = grid;
		i = 0;
	}

	public inline function hasNext() {
		return i < grid.size;
	}

	public inline function next(): GridItem<T> {
		var idx = i;
		var t = grid.getAt(i);
		var pos = grid.coord(i);
		i++;

		return {
			idx: idx,
			x: pos.x,
			y: pos.y,
			pos: pos,
			value: t
		};
	}
}
