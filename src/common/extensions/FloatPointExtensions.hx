package common.extensions;

import common.struct.Coordinate;
import common.struct.FloatPoint;

class FloatPointExtensions {
	public static inline function lerp(a: FloatPoint, b: FloatPoint, t: Float): FloatPoint {
		return {
			x: a.x.lerp(b.x, t),
			y: a.y.lerp(b.y, t),
		};
	}

	public static inline function asWorld(p: FloatPoint): Coordinate {
		return new Coordinate(p.x, p.y, WORLD);
	}

	public static inline function asPixel(p: FloatPoint): Coordinate {
		return new Coordinate(p.x, p.y, PIXEL);
	}

	public static inline function multiply(p: FloatPoint, v: Float): FloatPoint {
		return {
			x: p.x * v,
			y: p.y * v,
		};
	}
}
