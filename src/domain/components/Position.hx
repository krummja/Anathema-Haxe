package domain.components;

import core.ecs.Component;
import common.struct.Coordinate;


class Position extends Component
{
    public var x(get, null): Float;
    public var y(get, null): Float;
    public var space(get, null): CoordinateSpace;

    private var coordinate: Coordinate;

    public function new(x: Float, y: Float)
    {
        this.coordinate = new Coordinate(x, y, WORLD);
    }

    public function setPosition(x: Float, y: Float): Void
    {
        this.coordinate = new Coordinate(x, y, WORLD);
    }

    public function move(x: Float, y: Float): Void
    {
        var newX = this.x + 1;
        var newY = this.y + 1;
        this.coordinate = new Coordinate(newX, newY, WORLD);
    }

    private inline function get_x(): Float
    {
        return this.coordinate.x;
    }

    private inline function get_y(): Float
    {
        return this.coordinate.y;
    }

    private inline function get_space(): CoordinateSpace
    {
        return this.coordinate.space;
    }
}
