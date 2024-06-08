package common.extensions;


class IntExtensions
{
    public static inline function clamp(n: Int, min: Int, max: Int): Int
    {
        if (n > max) return max;
        if (n < min) return min;
        return n;
    }
}
