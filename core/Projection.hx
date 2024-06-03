package core;


class Projection
{
    private static var loop(get, null): core.MainLoop;

    public static function worldToPx(wx: Float, wy: Float): Coordinate
    {
        return new Coordinate(wx * loop.UNIT_X, wy * loop.UNIT_Y, PIXEL);
    }

    public static function pxToWorld(px: Float, py: Float): Coordinate
    {
        return new Coordinate(px / loop.UNIT_X, py * loop.UNIT_Y, WORLD);
    }

    public static function screenToPx(sx: Float, sy: Float): Coordinate
    {
        var camPix = worldToPx(loop.camera.x, loop.camera.y);
        var px = camPix.x + (sx / loop.camera.zoom);
        var py = camPix.y + (sy/ loop.camera.zoom);
        return new Coordinate(px, py, PIXEL);
    }

    public static function pxToScreen(px: Float, py: Float): Coordinate
    {
        var camPix = worldToPx(loop.camera.x, loop.camera.y);
        var sx = (px - camPix.x) * loop.camera.zoom;
        var sy = (py - camPix.y) * loop.camera.zoom;
        return new Coordinate(sx, sy, SCREEN);
    }

    public static function screenToWorld(sx: Float, sy: Float): Coordinate
    {
        var p = screenToPx(sx, sx);
        return pxToWorld(p.x, p.y);
    }

    public static function worldToScreen(wx: Float, wy: Float): Coordinate
    {
        var px = worldToPx(wx, wy);
        return pxToScreen(px.x, px.y);
    }

    private inline static function get_loop(): core.MainLoop
    {
        return MainLoop.instance;
    }
}
