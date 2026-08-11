package engine;

import common.struct.Coordinate;

class Projection {
	private static var loop(get, null): MainLoop;

	private static var zoneWidth(get, null): Int;
	private static var zoneHeight(get, null): Int;

	private static inline function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}

	private static inline function get_zoneWidth(): Int {
		return loop.world.zoneWidth;
	}

	private static inline function get_zoneHeight(): Int {
		return loop.world.zoneHeight;
	}

	// TO SCREEN

	public static function pixelToScreen(px: Float, py: Float): Coordinate {
		var camPix = worldToPixel(loop.camera.x, loop.camera.y);
		var sx = (px - camPix.x) * loop.camera.zoom;
		var sy = (py - camPix.y) * loop.camera.zoom;
		return new Coordinate(sx, sy, SCREEN);
	}

	public static function worldToScreen(wx: Float, wy: Float): Coordinate {
		var px = worldToPixel(wx, wy);
		return pixelToScreen(px.x, px.y);
	}

	public static function zoneToScreen(zx: Float, zy: Float): Coordinate {
		var px = zoneToPixel(zx, zy);
		return pixelToScreen(px.x, px.y);
	}

	// TO PIXEL

	public static function screenToPixel(sx: Float, sy: Float): Coordinate {
		var camPix = worldToPixel(loop.camera.x, loop.camera.y);
		var px = camPix.x + (sx / loop.camera.zoom);
		var py = camPix.y + (sy / loop.camera.zoom);
		return new Coordinate(px, py, PIXEL);
	}

	public static function worldToPixel(wx: Float, wy: Float): Coordinate {
		return new Coordinate(wx * loop.UNIT_X, wy * loop.UNIT_Y, PIXEL);
	}

	public static function zoneToPixel(zx: Float, zy: Float): Coordinate {
		var world = zoneToWorld(zx, zy);
		return worldToPixel(world.x, world.y);
	}

	// TO WORLD

	public static function screenToWorld(sx: Float, sy: Float): Coordinate {
		var p = screenToPixel(sx, sy);
		return pixelToWorld(p.x, p.y);
	}

	public static function pixelToWorld(px: Float, py: Float): Coordinate {
		return new Coordinate(px / loop.UNIT_X, py / loop.UNIT_Y, WORLD);
	}

	public static function zoneToWorld(zx: Float, zy: Float): Coordinate {
		return new Coordinate(zx * zoneWidth, zy * zoneHeight, WORLD);
	}

	// TO ZONE

	public static function screenToZone(sx: Float, sy: Float): Coordinate {
		var w = screenToWorld(sx, sy);
		return worldToZone(w.x, w.y);
	}

	public static function pixelToZone(px: Float, py: Float): Coordinate {
		var w = pixelToWorld(px, py);
		return new Coordinate(w.x / zoneWidth, w.y / zoneHeight, ZONE);
	}

	public static function worldToZone(wx: Float, wy: Float): Coordinate {
		return new Coordinate(Math.floor(wx / zoneWidth), Math.floor(wy / zoneHeight), ZONE);
	}
}
