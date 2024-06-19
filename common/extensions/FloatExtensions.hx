package common.extensions;


class FloatExtensions
{
    public static inline function clamp(n: Float, min: Float, max: Float): Float
    {
        if (n > max)
        {
            return max;
        }

        if (n < min)
        {
            return min;
        }

        return n;
    }

    public static inline function floor(n: Float): Int
    {
        return Math.floor(n);
    }

    public static inline function ceil(n: Float): Int
    {
        return Math.ceil(n);
    }

    public static inline function round(n: Float): Int
    {
        return Math.round(n);
    }

    public static inline function pow(n: Float, exp: Float): Float
    {
        return Math.pow(n, exp);
    }

    public static inline function toDegrees(n: Float): Float
    {
        return n * (180 / Math.PI);
    }

    public static inline function toRadians(n: Float): Float
    {
        return n / (180 / Math.PI);
    }

    public static inline function lerp(from: Float, to: Float, rate: Float): Float
    {
        return from + rate * (to - from);
    }
}
