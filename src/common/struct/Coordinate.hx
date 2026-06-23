package common.struct;

enum CoordinateSpace {
	SCREEN;
	PIXEL;
	WORLD;
	CHUNK;
	ZONE;
}

class Coordinate {
	public final x: Float;
	public final y: Float;
	public final space: CoordinateSpace;

	public function new(x: Float, y: Float, space: CoordinateSpace) {
		this.x = x;
		this.y = y;
		this.space = space;
	}

	public inline function toIntPoint(): IntPoint {
		return new IntPoint(Math.floor(this.x), Math.floor(this.y));
	}

	public inline function toFloatPoint(): FloatPoint {
		return new FloatPoint(this.x, this.y);
	}

	public function toString(): String {
		return "(" + Std.string(this.x) + ", " + Std.string(this.y) + ")";
	}
}
