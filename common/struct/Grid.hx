package common.struct;


@:generic
class Grid<T>
{
    public var width(default, null): Int;
    public var height(default, null): Int;
    public var size(get, null): Int;

    public var data: FixedArray<T>;

    public function new(width: Int = 128, height: Int = 128)
    {
        this.width = width;
        this.height = height;
        this.data = new FixedArray(width * height);
    }

    public function fill(value: T): Void
    {
        for (idx in 0...this.size)
        {
            this.data.set(idx, value);
        }
    }

    public function fillFn(fn: (Int) -> T): Void
    {
        for (idx in 0...this.size)
        {
            this.data.set(idx, fn(idx));
        }
    }

    public inline function id(x: Int, y: Int): Int
    {
        return y * this.width + x;
    }

    public function get(x: Int, y: Int): T
    {
        if (this.isOutOfBounds(x, y)) return null;
        var idx = this.id(x, y);
        return this.data.get(idx);
    }

    public inline function getAt(id: Int): T
    {
        return this.data.get(id);
    }

    public inline function isOutOfBounds(x: Int, y: Int): Bool
    {
        return this.isXOutOfBounds(x) || this.isYOutOfBounds(y);
    }

    public inline function isXOutOfBounds(x: Int): Bool
    {
        return x < 0 || x >= this.width;
    }

    public inline function isYOutOfBounds(y: Int): Bool
    {
        return y < 0 || y >= this.height;
    }

    private function get_size(): Int
    {
        return this.height * this.width;
    }
}
