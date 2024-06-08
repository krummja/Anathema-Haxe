package common.struct;


enum CoordinateSpace
{
    SCREEN;
    PIXEL;
    WORLD;
}


class Coordinate
{
    public final x: Float;
    public final y: Float;
    public final space: CoordinateSpace;

    public function new(x: Float, y: Float, space: CoordinateSpace)
    {
        this.x = x;
        this.y = y;
        this.space = space;
    }

    public function toString(): String
    {
        return "(" + Std.string(this.x) + ", " + Std.string(this.y) + ")";
    }
}
