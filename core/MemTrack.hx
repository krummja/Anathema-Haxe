package core;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
#end

import common.util.MathLib as M;


class MemAlloc
{
    public var total = 0.0;
    public var calls = 0;

    public inline function new() {}
}


class MemTrack
{
    @:noCompletion
    public static var allocs: Map<String, MemAlloc> = new Map();

    @:noCompletion
    public static var firstMeasure = -1.0;

    /**
     * Measure a block or a function call memory usage.
     */
    public static macro function measure(e: Expr, ?ename: ExprOf<String>)
    {
        #if !debug
        return e;
        #else
        var p = Context.getPosInfos(Context.currentPos());
        var id = Context.getLocalModule() + "." + Context.getLocalMethod() + "@" + p.min + ": ";

        id += switch e.expr
        {
            case ECall(e, params):
                haxe.macro.ExprTools.toString(e) + "()";

            case EBlock(_):
                "<block>";

            case _:
                '<${e.expr.getName()}>';
        }

        switch ename.expr
        {
            case EConst(CIdent("null")):
            case _: id += ".";
        }

        return macro
        {
            if (sim.debug.MemTrack.firstMeasure < 0)
            {
                sim.debug.MemTrack.firstMeasure = haxe.Timer.stamp();
            }

            var old = sim.Gc.getCurrentMem();

            $e;

            var m = sim.MathLib.fmax(0, sim.Gc.getCurrentMem() - old);

            var id = $v{id};

            if ($ename != null)
            {
                id += $ename;
            }

            if (!sim.debug.MemTrack.allocs.exists(id))
            {
                sim.debug.MemTrack.allocs.set(id, new sim.debug.MemTrack.MemAlloc());
            }

            var alloc = sim.debug.MemTrack.allocs.get(id);
            alloc.total += m;
            alloc.calls++;
        }
        #end
    }

    public static function reset(): Void
    {
        MemTrack.allocs = new Map();
        MemTrack.firstMeasure = -1;
    }

    public static function report(?printer: String -> Void, alsoReset: Bool = true): Void
    {
        var t = haxe.Timer.stamp() - MemTrack.firstMeasure;

        if (printer == null) printer = (v) -> trace(v);

        var all = [];

        for (a in MemTrack.allocs.keyValueIterator())
        {
            all.push({ id: a.key, mem: a.value });
        }

        all.sort((a, b) -> {
            -Reflect.compare(a.mem.total / t, b.mem.total / t);
        });

        if (all.length==0)
        {
            printer("MemTrack has nothing to report.");
            return;
        }

        printer("MEMTRACK REPORT");
        printer("Elapsed Time: " + '${M.pretty(t, 1)}s');

        var table = [["", "MEM/S", "TOTAL"]];
        var total = 0.0;

        for (a in all)
        {
            total += a.mem.total;
            table.push([
                a.id,
                M.unit(a.mem.total / t) + "/s",
                M.unit(a.mem.total),
            ]);
        }

        var colWidths: Array<Int> = [];

        for (line in table)
        {
            for (i in 0...line.length)
            {
                if (!M.isValidNumber(colWidths[i])) colWidths[i] = line[i].length;
                else colWidths[i] = M.imax(colWidths[i], line[i].length);
            }
        }

        inline function _separator() {
            return [ for (i in 0...colWidths.length) padRight("", colWidths[i], "-") ];
        }

        table.insert(1, _separator());
        table.push(_separator());
        table.push(["", M.unit(total / t) + "/s", M.unit(total)]);

        for (line in table)
        {
            for (i in 0...line.length)
                line[i] = padRight(line[i], colWidths[i]);
            printer("| " + line.join(" | ") + " |");
        }

        if (alsoReset)
            MemTrack.reset();
    }

    private static inline function padRight(str: String, minLen: Int, padChar=" "): String
    {
        while (str.length < minLen)
        {
            str += padChar;
        }

        return str;
    }
}
