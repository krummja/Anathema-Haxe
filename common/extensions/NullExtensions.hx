package common.extensions;

class NullExtensions
{
    public static inline function isNull<T>(nullable: Null<T>): Bool
    {
        return nullable == null;
    }
}
