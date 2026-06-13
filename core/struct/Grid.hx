package core.struct;


@:allow(core.struct.GridIterator)
class Grid<T> {
    public var width(default, null): Int;
    public var height(default, null): Int;

    private var data: Map<Int, T>;

    public function new(width: Int, height: Int) {
        this.width = width;
        this.height = height;
        this.data = new Map();
    }

    @:keep
    public inline function toString() {
        return 'Grid(${width}x${height})';
    }

    public inline function iterator() {
        return new GridIterator(this);
    }

    public inline function isValid(x: Int, y: Int) {
        return x >= 0 && x < width && y >= 0 && y < height;
    }

    private inline function coordId(x: Int, y: Int) {
        return x + y * width;
    }

    public inline function set(x: Int, y: Int, value: T) {
        if (isValid(x, y)) {
            data.set(coordId(x, y), value);
        }
    }

    public inline function get(x: Int, y: Int): Null<T> {
        return isValid(x, y) ? data.get(coordId(x, y)) : null;
    }

    public inline function hasValue(x: Int, y: Int): Bool {
        return isValid(x, y) && data.get(coordId(x, y)) != null;
    }

    public inline function remove(x: Int, y: Int) {
        if (isValid(x, y)) {
            data.remove(coordId(x, y));
        }
    }

    public inline function fill(value: T) {
        for (x in 0...width) {
            for (y in 0...height) {
                data.set(coordId(x, y), value);
            }
        }
    }

    public inline function empty() {
        data = new Map();
    }
}

private class GridIterator<T> {
    private var grid: Grid<T>;
    private var i: Int;

    public inline function new(grid: Grid<T>) {
        this.grid = grid;
        this.i = 0;
    }

    public inline function hasNext(): Bool {
        return this.i < this.grid.width * this.grid.height;
    }

    public inline function next() {
        return this.grid.data.get(this.i++);
    }
}
