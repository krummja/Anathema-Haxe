package core;

import h2d.Object;


class Camera
{
    public var width(get, null): Float;
    public var height(get, null): Float;
    public var zoom(get, set): Float;
    public var pos(get, set): Coordinate;
    public var x(get, set): Float;
    public var y(get, set): Float;
    public var focus(get, set): Coordinate;
    public var scroller(get, null): h2d.Object;

    public function new()
    {
        this.zoom = 1;
    }

    private inline function get_width(): Float
    {
        return hxd.Window.getInstance().width;
    }

    private inline function get_height(): Float
    {
        return hxd.Window.getInstance().height;
    }

    private function get_zoom(): Float
    {
        return scroller.scaleX;
    }

    private function set_zoom(value: Float): Float
    {
        scroller.setScale(value);
        return value;
    }

    private function get_pos(): Coordinate
    {
        return new Coordinate(x, y, WORLD);
    }

    private function set_pos(value: Coordinate): Coordinate
    {
        var w = value.toWorld();
        x = w.x;
        y = w.y;
        return w;
    }

    private function get_x(): Float
    {
        var c = Projection.pxToWorld(-scroller.x / zoom, -scroller.y / zoom);
        return c.x;
    }

    private function set_x(value: Float): Float
    {
        var p = Projection.worldToPx(value, y);
        scroller.x = -(p.x * zoom).floor();
        scroller.y = -(p.y * zoom).floor();
        return value;
    }

    private function get_y(): Float
    {
        var c = Projection.pxToWorld(-scroller.x / zoom, -scroller.y / zoom);
        return c.y;
    }

    private function set_y(value: Float): Float
    {
        var p = Projection.worldToPx(x, value);
        scroller.x = -(p.x * zoom).floor();
        scroller.y = -(p.y * zoom).floor();
        return value;
    }

    private function get_scroller(): Object
    {
        return MainLoop.instance.layers.scroller;
    }

    private function get_focus(): Coordinate
    {
        return new Coordinate(width / 2, height / 2, SCREEN);
    }

    private function set_focus(value: Coordinate): Coordinate
    {
        var mid = new Coordinate(width / 2, height / 2, SCREEN);
        pos = value.sub(mid).add(pos);
        return pos;
    }
}
