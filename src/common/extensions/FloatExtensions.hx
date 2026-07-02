package common.extensions;

class FloatExtensions {
	public static inline function toDegrees(n: Float): Float {
		return n * (180 / Math.PI);
	}

	public static inline function toRadians(n: Float): Float {
		return n / (180 / Math.PI);
	}

	public static inline function lerp(from: Float, to: Float, rate: Float): Float {
		return from + rate * (to - from);
	}

	public static inline function clamp(n: Float, min: Float, max: Float): Float {
		if (n > max) {
			return max;
		}

		if (n < min) {
			return min;
		}

		return n;
	}

	public static function nthRoot(n: Float, root: Float): Float {
		return Math.pow(n, 1 / root);
	}
}
