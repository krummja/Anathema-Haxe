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
}
