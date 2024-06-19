package common.extensions;


class IterableExtensions
{
    public static function max<T>(it: Iterable<T>, fn: (value: T) -> Float): T
    {
        var cur: Null<T> = null;
        var curWeight = Math.NEGATIVE_INFINITY;

        for (value in it)
        {
            var weight = fn(value);
            if (cur.isNull() || weight > curWeight)
            {
                curWeight = weight;
                cur = value;
            }
        }

        return cur;
    }

    public static function min<T>(it: Iterable<T>, fn: (value: T) -> Float): T
    {
        var cur: Null<T> = null;
        var curWeight = Math.POSITIVE_INFINITY;

        for (value in it)
        {
            var weight = fn(value);
            if (cur.isNull() || weight < curWeight)
            {
                curWeight = weight;
                cur = value;
            }
        }

        return cur;
    }

    public static overload extern inline function each<A>(it: Iterable<A>, fn: (item: A, idx: Int) -> Void)
    {
        var i = 0;
        for (x in it)
        {
            fn(x, i++);
        }
    }

    public static overload extern inline function each<A>(it: Iterable<A>, fn: (item: A) -> Void)
    {
        for (x in it)
        {
            fn(x);
        }
    }

    public static inline function has<T>(it: Iterable<T>, value: T): Bool
    {
        return Lambda.has(it, value);
    }

    public static inline function find<T>(it: Iterable<T>, fn: (value: T) -> Bool): T
    {
        return Lambda.find(it, fn);
    }

    public static inline function exists<T>(it: Iterable<T>, fn: (value: T) -> Bool): Bool
    {
        return Lambda.exists(it, fn);
    }
}
