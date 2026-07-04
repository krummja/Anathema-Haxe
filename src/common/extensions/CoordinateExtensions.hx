package common.extensions;

import common.util.Easing;
import common.util.Easing.EasingType;
import engine.MainLoop;
import engine.Projection;
import common.algorithm.Distance;
import common.struct.Coordinate;
import common.struct.FloatPoint;

class CoordinateExtensions {
	public static inline function lift(c: Coordinate, space: CoordinateSpace): Coordinate {
		var px = c.toPixel();
		return switch space {
			case SCREEN: Projection.pixelToScreen(px.x, px.y);
			case PIXEL: px;
			case WORLD: Projection.pixelToWorld(px.x, px.y);
			case CHUNK: Projection.pixelToChunk(px.x, px.y);
			case ZONE: Projection.pixelToZone(px.x, px.y);
		}
	}

	public static inline function toScreen(c: Coordinate): Coordinate {
		return switch c.space {
			case SCREEN: c;
			case PIXEL: Projection.pixelToScreen(c.x, c.y);
			case WORLD: Projection.worldToScreen(c.x, c.y);
			case CHUNK: Projection.chunkToScreen(c.x, c.y);
			case ZONE: Projection.zoneToScreen(c.x, c.y);
		}
	}

	public static inline function toPixel(c: Coordinate): Coordinate {
		return switch c.space {
			case SCREEN: Projection.screenToPixel(c.x, c.y);
			case PIXEL: c;
			case WORLD: Projection.worldToPixel(c.x, c.y);
			case CHUNK: Projection.chunkToPixel(c.x, c.y);
			case ZONE: Projection.zoneToPixel(c.x, c.y);
		}
	}

	public static inline function toWorld(c: Coordinate): Coordinate {
		return switch c.space {
			case SCREEN: Projection.screenToWorld(c.x, c.y);
			case PIXEL: Projection.pixelToWorld(c.x, c.y);
			case WORLD: c;
			case CHUNK: Projection.chunkToWorld(c.x, c.y);
			case ZONE: Projection.zoneToWorld(c.x, c.y);
		}
	}

	public static inline function toChunk(c: Coordinate): Coordinate {
		return switch c.space {
			case SCREEN: Projection.screenToChunk(c.x, c.y);
			case PIXEL: Projection.pixelToChunk(c.x, c.y);
			case WORLD: Projection.worldToChunk(c.x, c.y);
			case CHUNK: c;
			case ZONE: Projection.zoneToChunk(c.x, c.y);
		}
	}

	public static inline function toZone(c: Coordinate): Coordinate {
		return switch c.space {
			case SCREEN: Projection.screenToZone(c.x, c.y);
			case PIXEL: Projection.pixelToZone(c.x, c.y);
			case WORLD: Projection.worldToZone(c.x, c.y);
			case CHUNK: Projection.chunkToZone(c.x, c.y);
			case ZONE: c;
		}
	}

	public static inline function toChunkLocal(a: Coordinate): Coordinate {
		var chunk = a.toChunk().floor();
		return a.sub(chunk);
	}

	public static inline function toChunkId(a: Coordinate): Int {
		var c = a.toChunk();
		return MainLoop.getInstance().world.chunks.getChunkIdx(c.x, c.y);
	}

	public static inline function toZoneId(a: Coordinate): Int {
		var c = a.toZone();
		return MainLoop.getInstance().world.zones.getZoneId(c.toIntPoint());
	}

	public static inline function add(a: Coordinate, b: Coordinate): Coordinate {
		var projected = b.lift(a.space);
		return new Coordinate(a.x + projected.x, a.y + projected.y, a.space);
	}

	public static inline function sub(a: Coordinate, b: Coordinate): Coordinate {
		var projected = b.lift(a.space);
		return new Coordinate(a.x - projected.x, a.y - projected.y, a.space);
	}

	public static inline function floor(c: Coordinate): Coordinate {
		return new Coordinate(Math.floor(c.x), Math.floor(c.y), c.space);
	}

	public static inline function distance(a: Coordinate, b: Coordinate, space: CoordinateSpace = WORLD, formula: DistanceFormula = EUCLIDEAN): Float {
		var pa = a.lift(space).toFloatPoint();
		var pb = b.lift(space).toFloatPoint();
		return Distance.Get(pa, pb, formula);
	}

	public static inline function lerp(a: Coordinate, b: Coordinate, time: Float): Coordinate {
		var projected = b.lift(a.space);
		return new Coordinate(a.x.lerp(projected.x, time), a.y.lerp(projected.y, time), a.space);
	}

	public static inline function lengthSq(a: Coordinate): Float {
		return a.x * a.x + a.y * a.y;
	}

	public static inline function normalized(a: Coordinate): FloatPoint {
		var k = lengthSq(a);
		if (k < hxd.Math.EPSILON) k = 0;
		else
			k = hxd.Math.invSqrt(k);

		return {
			x: a.x * k,
			y: a.y * k,
		};
	}

	public static inline function equals(a: Coordinate, b: Coordinate): Bool {
		return a.space == b.space && a.x == b.x && a.y == b.y;
	}

	public static inline function direction(a: Coordinate, b: Coordinate): FloatPoint {
		return b.sub(a).normalized();
	}

	public static inline function angTo(a: Coordinate, b: Coordinate): Float {
		var pxa = a.toPixel();
		var pxb = b.toPixel();
		return Math.atan2(pxb.y - pxa.y, pxb.x - pxa.x);
	}

	public static inline function ease(a: Coordinate, b: Coordinate, x: Float, easing: EasingType): Coordinate {
		var progress = Easing.apply(x, easing);
		var direction = a.direction(b);
		var distance = a.toWorld().distance(b.toWorld(), EUCLIDEAN);

		var newPx = direction.multiply(progress * distance);
		return newPx.asWorld().add(a);
	}
}
