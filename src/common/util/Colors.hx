package common.util;

typedef RGB = {
	r: Int,
	g: Int,
	b: Int,
}

class Colors {
	public static inline function components(c: Int): RGB {
		return {
			r: (c & 0xff0000) >> 16,
			g: (c & 0x00ff00) >> 8,
			b: (c & 0x0000ff)
		};
	}

	public static inline function toHex(r: Int, g: Int, b: Int): Int {
		return (r << 16) + (g << 8) + (b);
	}

	public static function mixPart(p1: Float, p2: Float, t: Float): Float {
		var v = (1 - t) * Math.pow(p1, 2) + t * Math.pow(p2, 2);
		return v.nthRoot(2);
	}

	public static function mix(a: Int, b: Int, t: Float = 0.5): Int {
		var c1 = components(a);
		var c2 = components(b);

		var r = Math.round(mixPart(c1.r, c2.r, t).clamp(0, 255));
		var g = Math.round(mixPart(c1.g, c2.g, t).clamp(0, 255));
		var b = Math.round(mixPart(c1.b, c2.b, t).clamp(0, 255));

		return toHex(r, g, b);
	}
}
