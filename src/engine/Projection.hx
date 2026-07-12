package engine;

import common.struct.Coordinate;

class Projection {
	private static var loop(get, null): MainLoop;

	private static var chunkSize(get, null): Int;

	private inline static function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}

	private inline static function get_chunkSize(): Int {
		return loop.world.chunkSize;
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

	public static function chunkToScreen(cx: Float, cy: Float): Coordinate {
		var px = chunkToPixel(cx, cy);
		return pixelToScreen(px.x, px.y);
	}

	public static function zoneToScreen(zx: Float, zy: Float): Coordinate {
		var chunk = zoneToChunk(zx, zy);
		return chunkToScreen(chunk.x, chunk.y);
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

	public static function chunkToPixel(cx: Float, cy: Float): Coordinate {
		var world = chunkToWorld(cx, cy);
		return worldToPixel(world.x, world.y);
	}

	public static function zoneToPixel(zx: Float, zy: Float): Coordinate {
		var chunk = zoneToChunk(zx, zy);
		return chunkToPixel(chunk.x, chunk.y);
	}

	// TO WORLD

	public static function screenToWorld(sx: Float, sy: Float): Coordinate {
		var p = screenToPixel(sx, sy);
		return pixelToWorld(p.x, p.y);
	}

	public static function pixelToWorld(px: Float, py: Float): Coordinate {
		return new Coordinate(px / loop.UNIT_X, py / loop.UNIT_Y, WORLD);
	}

	public static function chunkToWorld(cx: Float, cy: Float): Coordinate {
		return new Coordinate(cx * chunkSize, cy * chunkSize, WORLD);
	}

	public static function zoneToWorld(zx: Float, zy: Float): Coordinate {
		var chunk = zoneToChunk(zx, zy);
		return chunkToWorld(chunk.x, chunk.y);
	}

	// TO CHUNK

	public static function screenToChunk(sx: Float, sy: Float): Coordinate {
		var w = screenToWorld(sx, sy);
		return worldToChunk(w.x, w.y);
	}

	public static function pixelToChunk(px: Float, py: Float): Coordinate {
		var w = pixelToWorld(px, py);
		return new Coordinate(w.x / chunkSize, w.y / chunkSize, CHUNK);
	}

	public static function worldToChunk(wx: Float, wy: Float): Coordinate {
		return new Coordinate(Math.floor(wx / chunkSize), Math.floor(wy / chunkSize), CHUNK);
	}

	public static function zoneToChunk(zx: Float, zy: Float): Coordinate {
		var cs = loop.world.chunkSubdivision;
		return new Coordinate(zx * cs, zy * cs, CHUNK);
	}

	// TO ZONE

	public static function screenToZone(sx: Float, sy: Float): Coordinate {
		var c = screenToChunk(sx, sy);
		return chunkToZone(c.x, c.y);
	}

	public static function pixelToZone(px: Float, py: Float): Coordinate {
		var chunk = pixelToChunk(px, py);
		return chunkToZone(chunk.x, chunk.y);
	}

	public static function worldToZone(wx: Float, wy: Float): Coordinate {
		var chunk = worldToChunk(wx, wy);
		return chunkToZone(chunk.x, chunk.y);
	}

	public static function chunkToZone(cx: Float, cy: Float): Coordinate {
		var cs = loop.world.chunkSubdivision;
		return new Coordinate(cx / cs, cy / cs, ZONE);
	}
}
