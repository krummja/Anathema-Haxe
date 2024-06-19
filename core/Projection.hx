package core;

import common.struct.Coordinate;


class Projection
{
    private static var loop(get, null): core.MainLoop;

    // TO SCREEN

    public static function pixelToScreen(px: Float, py: Float): Coordinate
    {
        var camPix = worldToPixel(loop.camera.x, loop.camera.y);
        var sx = (px - camPix.x) * loop.camera.zoom;
        var sy = (py - camPix.y) * loop.camera.zoom;
        return new Coordinate(sx, sy, SCREEN);
    }

    public static function worldToScreen(wx: Float, wy: Float): Coordinate
    {
        var px = worldToPixel(wx, wy);
        return pixelToScreen(px.x, px.y);
    }

    public static function chunkToScreen(cx: Float, cy: Float): Coordinate
    {
        return new Coordinate(0.0, 0.0, SCREEN);
    }

    public static function zoneToScreen(zx: Float, zy: Float): Coordinate
    {
        return new Coordinate(0.0, 0.0, SCREEN);
    }

    // TO PIXEL

    public static function screenToPixel(sx: Float, sy: Float): Coordinate
    {
        var camPix = worldToPixel(loop.camera.x, loop.camera.y);
        var px = camPix.x + (sx / loop.camera.zoom);
        var py = camPix.y + (sy/ loop.camera.zoom);
        return new Coordinate(px, py, PIXEL);
    }

    public static function worldToPixel(wx: Float, wy: Float): Coordinate
    {
        return new Coordinate(wx * loop.UNIT_X, wy * loop.UNIT_Y, PIXEL);
    }

    public static function chunkToPixel(cx: Float, cy: Float): Coordinate
    {
        return new Coordinate(0.0, 0.0, PIXEL);
    }

    public static function zoneToPixel(zx: Float, zy: Float): Coordinate
    {
        return new Coordinate(0.0, 0.0, PIXEL);
    }

    // TO WORLD

    public static function screenToWorld(sx: Float, sy: Float): Coordinate
    {
        var p = screenToPixel(sx, sx);
        return pixelToWorld(p.x, p.y);
    }

    public static function pixelToWorld(px: Float, py: Float): Coordinate
    {
        return new Coordinate(px / loop.UNIT_X, py * loop.UNIT_Y, WORLD);
    }

    public static function chunkToWorld(cx: Float, cy: Float): Coordinate
    {
        return new Coordinate(0.0, 0.0, WORLD);
    }

    public static function zoneToWorld(zx: Float, zy: Float): Coordinate
    {
        return new Coordinate(0.0, 0.0, WORLD);
    }

    // TO CHUNK

    public static function screenToChunk(sx: Float, sy: Float): Coordinate
    {
        return new Coordinate(0.0, 0.0, CHUNK);
    }

    public static function pixelToChunk(px: Float, py: Float): Coordinate
    {
        return new Coordinate(0.0, 0.0, CHUNK);
    }

    public static function worldToChunk(wx: Float, wy: Float): Coordinate
    {
        return new Coordinate(0.0, 0.0, CHUNK);
    }

    public static function zoneToChunk(zx: Float, zy: Float): Coordinate
    {
        return new Coordinate(0.0, 0.0, CHUNK);
    }

    // TO ZONE

    public static function screenToZone(sx: Float, sy: Float): Coordinate
    {
        return new Coordinate(0.0, 0.0, ZONE);
    }

    public static function pixelToZone(zx: Float, zy: Float): Coordinate
    {
        return new Coordinate(0.0, 0.0, ZONE);
    }

    public static function worldToZone(wx: Float, wy: Float): Coordinate
    {
        return new Coordinate(0.0, 0.0, ZONE);
    }

    public static function chunkToZone(cx: Float, cy: Float): Coordinate
    {
        return new Coordinate(0.0, 0.0, ZONE);
    }

    private inline static function get_loop(): core.MainLoop
    {
        return MainLoop.instance;
    }
}
