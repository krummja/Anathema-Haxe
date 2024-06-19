package core;

class Gc
{
    private static var _active: Bool = true;

    public static function isSupported(): Bool
    {
        #if hl
            return true;
        #else
            return false;
        #end
    }

    public static inline function isActive(): Bool
    {
        return Gc._active && Gc.isSupported();
    }

    public static inline function setState(active: Bool): Void
    {
        #if hl
            hl.Gc.enable(active);
            Gc._active = active;
        #end
    }

    public static inline function enable()
    {
        Gc.setState(true);
    }

    public static inline function disable()
    {
        Gc.setState(false);
    }

    public static inline function getCurrentMem(): Float
    {
        #if hl
            var _ = 0.0, v = 0.0;
            @:privateAccess hl.Gc._stats(_, _, v);
            return v;
        #else
            return 0;
        #end
    }

    public static inline function getAllocationCount(): Float
    {
        #if hl
            var _ = 0.0, v = 0.0;
            @:privateAccess hl.Gc._stats(_, v, _);
            return v;
        #else
            return 0;
        #end
    }

    public static inline function getTotalAllocated(): Float
    {
        #if hl
            var _ = 0.0, v = 0.0;
            @:privateAccess hl.Gc._stats(v, _, _);
            return v;
        #else
            return 0;
        #end
    }

    public static inline function runNow(): Void
    {
        #if hl
        hl.Gc.enable(true);
        hl.Gc.major();
        hl.Gc.enable(_active);
        #end
    }
}
