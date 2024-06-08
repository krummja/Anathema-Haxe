package common.extensions;

import common.struct.Coordinate;
import core.Projection;


class CoordinateExtensions
{
    public static inline function toSpace(c: Coordinate, space: CoordinateSpace): Coordinate
    {
        var px = c.toPx();
        return switch space
        {
            case PIXEL: px;
            case SCREEN: Projection.pxToScreen(px.x, px.y);
            case WORLD: Projection.pxToWorld(px.x, px.y);
        }
    }

    public static inline function toWorld(c: Coordinate): Coordinate
    {
        return switch c.space
        {
            case PIXEL: Projection.pxToWorld(c.x, c.y);
            case SCREEN: Projection.screenToWorld(c.x, c.y);
            case WORLD: c;
        }
    }

    public static inline function toPx(c: Coordinate): Coordinate
    {
        return switch c.space
        {
            case PIXEL: c;
            case SCREEN: Projection.screenToPx(c.x, c.y);
            case WORLD: Projection.worldToPx(c.x, c.y);
        }
    }

    public static inline function add(a: Coordinate, b: Coordinate): Coordinate
    {
        var projected = b.toSpace(a.space);
        return new Coordinate(a.x - projected.x, a.y - projected.y, a.space);
    }

    public static inline function sub(a: Coordinate, b: Coordinate): Coordinate
    {
        var projected = b.toSpace(a.space);
        return new Coordinate(a.x + projected.x, a.y + projected.y, a.space);
    }
}
