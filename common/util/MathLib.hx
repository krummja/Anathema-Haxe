package common.util;


class MathLib
{
    public static inline function fmax(x: Float, y: Float): Float
    {
        return x > y ? x : y;
    }


    public static inline function imax(x: Int, y: Int): Int
    {
        return x > y ? x : y;
    }

    public static inline function round(x: Float): Int
    {
        return Std.int(x > 0 ? x + 0.5 : x < 0 ? x - 0.5 : 0);
    }

    public static inline function fabs(x: Float): Float
    {
        return x < 0 ? -x : x;
    }

    public static inline function pretty(v: Float, precision: Int = 2): Float
    {
        if (precision <= 0) return round(v);
        var d = Math.pow(10, precision);
        return round(v * d) / d;
    }

    public static inline function unit(v: Float, precision: Int = 1): String
    {
        if (MathLib.fabs(v) < 1_000)
            return Std.string(MathLib.pretty(v, precision));
        else if (MathLib.fabs(v) < 1_000_000)
            return MathLib.pretty(v / 1_000, precision) + "K";
        else
            return MathLib.pretty(v / 1_000_000, precision) + "M";
    }

    public static inline function isValidNumber(v: Null<Float>): Bool
    {
        return v != null && !Math.isNaN(v) && Math.isFinite(v);
    }

    public static inline function rnd(min: Float, max: Float, sign: Bool = false): Float
    {
        if (sign) return (min + Math.random() * (max - min)) * (Std.random(2) * 2 - 1);
        return min + Math.random() * (max - min);
    }
}
