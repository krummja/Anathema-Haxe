package common.struct;


@:generic
class GridMap<T : (String)>
{
    private var hash: Map<T, Int>;
    private var grid: Grid<Array<T>>;

    public var width(default, null): Int;
    public var height(default, null): Int;
    public var size(get, null): Int;

    public function new(width: Int = 128, height: Int = 128)
    {
        this.grid = new Grid(width, height);
        this.grid.fillFn((idx: Int) -> new Array());
        this.hash = new Map();
    }

    public function get(x: Int, y: Int): Array<T>
    {
        var res = this.grid.get(x, y);
        if (res.isNull()) return new Array<T>();
        return res.copy();
    }

    private function get_size(): Int
    {
        return this.width * this.height;
    }
}
