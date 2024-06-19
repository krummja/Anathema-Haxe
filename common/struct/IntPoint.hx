package common.struct;

import data.Cardinal;


@:structInit
class IntPoint
{
    public static function Equals(point: IntPoint, other: IntPoint): Bool
    {
        return other.x == point.x && other.y == point.y;
    }

    public final x: Int;
    public final y: Int;

    public inline function new(x: Int, y: Int)
    {
        this.x = x;
        this.y = y;
    }

    public function equals(other: IntPoint): Bool
    {
        return IntPoint.Equals(this, other);
    }

    public function asWorld(): Coordinate
    {
        return new Coordinate(this.x, this.y, WORLD);
    }

    public function asZone(): Coordinate
    {
        return new Coordinate(this.x, this.y, ZONE);
    }

    public function toString(): String
    {
        return '(${this.x},${this.y})';
    }

    public overload extern inline function sub(other: IntPoint): IntPoint
    {
        return new IntPoint(this.x - other.x, this.y - other.y);
    }

    public overload extern inline function sub(x: Int, y: Int): IntPoint
    {
        return new IntPoint(this.x - x, this.y - y);
    }

    public overload extern inline function add(other: IntPoint): IntPoint
    {
        return new IntPoint(this.x + other.x, this.y + other.y);
    }

    public overload extern inline function add(x: Int, y: Int): IntPoint
    {
        return new IntPoint(this.x + x, this.y + y);
    }

    public overload extern inline function multiply(value: Int): IntPoint
    {
        return new IntPoint(this.x * value, this.y * value);
    }

    public overload extern inline function divide(value: Int): FloatPoint
    {
        return new FloatPoint(this.x / value, this.y / value);
    }

    public inline function dot(other: IntPoint): Int
    {
        return (this.x + other.x) * (this.y + other.y);
    }

    public inline function toRadians(): Float
    {
        var rad = Math.atan2(this.y, this.x);
        return rad < 0 ? Math.PI * 2 + rad : rad;
    }

    public inline function toDegrees(): Float
    {
        return this.toRadians().toDegrees();
    }

    public inline function toCardinal(): Cardinal
    {
        return Cardinal.fromRadians(this.toRadians());
    }
}
