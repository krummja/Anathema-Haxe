package common.extensions;


class IntExtensions
{
    public static inline function clamp(n: Int, min: Int, max: Int): Int
    {
        if (n > max) return max;
        if (n < min) return min;
        return n;
    }

    public static inline function toHxdColor(n: Int, a: Float = 1): h3d.Vector4
    {
        var b = n & 0xff;
        var g = (n >> 8) & 0xff;
        var r = (n >> 16) & 0xff;
        return new h3d.Vector4(r / 255, g / 255, b / 255, a);
    }
}
