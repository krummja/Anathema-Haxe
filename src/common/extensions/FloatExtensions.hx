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
}
