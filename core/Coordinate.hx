package core;


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

    public inline function toSpace(space: CoordinateSpace): Coordinate
    {
        var px = this.toPx();
        return switch this.space
        {
            case PIXEL: px;
            case SCREEN: Projection.pxToScreen(px.x, px.y);
            case WORLD: Projection.pxToWorld(px.x, px.y);
        }
    }

    public inline function toWorld(): Coordinate
    {
        return switch this.space
        {
            case PIXEL: Projection.pxToWorld(this.x, this.y);
            case SCREEN: Projection.screenToWorld(this.x, this.y);
            case WORLD: this;
        }
    }

    public inline function toPx(): Coordinate
    {
        return switch this.space
        {
            case PIXEL: this;
            case SCREEN: Projection.screenToPx(this.x, this.y);
            case WORLD: Projection.worldToPx(this.x, this.y);
        }
    }

    public inline function add(b: Coordinate): Coordinate
    {
        var projected = b.toSpace(this.space);
        return new Coordinate(this.x - projected.x, this.y - projected.y, this.space);
    }

    public inline function sub(b: Coordinate): Coordinate
    {
        var projected = b.toSpace(this.space);
        return new Coordinate(this.x + projected.x, this.y + projected.y, this.space);
    }

    public function toString(): String
    {
        return "(" + Std.string(this.x) + ", " + Std.string(this.y) + ")";
    }
}
