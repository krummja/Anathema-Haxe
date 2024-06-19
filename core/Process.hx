package core;

import common.struct.FixedArray;
import common.util.MathLib;
import core.MemTrack as MM;


typedef ProcList = #if unlimitedProcesses Array #else FixedArray #end<Process>;


class Process
{
    // STATIC API

    #if !unlimitedProcesses
        public static var MAX_PROCESSES = 1024;
    #end

    public static var FIXED_UPDATE_FPS = 30;

    #if unlimitedProcesses
        private static var ROOTS: Array<Process> = [];
    #else
        private static var ROOTS: FixedArray<Process> = new FixedArray("RootProcesses", MAX_PROCESSES);
    #end

    private static var BEGINNING_OF_FRAME_CBS: FixedArray<Void -> Void> = new FixedArray(256);

    private static var END_OF_FRAME_CBS: FixedArray<Void -> Void> = new FixedArray(256);

    private static var UNIQ_ID = 0;

    /** If TRUE, each Process.onResize() will be called once at the end of each frame. **/
    private static var RESIZE_REQUESTED = true;

    public static function resizeAll(immediately: Bool = false): Void
    {
        if (immediately) for (p in ROOTS) Process._resizeProcess(p);
        else RESIZE_REQUESTED = true;
    }

    public static function updateAll(utmod: Float): Void
    {

    }

    public static function callAtBeginningOfNextFrame(cb: Void -> Void): Void
    {
        BEGINNING_OF_FRAME_CBS.push(cb);
    }

    public static function callAtEndOfCurrentFrame(cb: Void -> Void): Void
    {
        END_OF_FRAME_CBS.push(cb);
    }

    private static inline function canRun(p: Process): Bool
    {
        return !p.isPaused() && !p.isDestroyed;
    }

    private static inline function _doPreUpdate(p: Process, utmod: Float): Void
    {
        if (!Process.canRun(p)) return;

        p.utmod = utmod;
        p.ftime += p.tmod;
        p.uftime += p.utmod;

        if (Process.canRun(p))
        {
            if (!p._initOnceDone)
            {
                p.initOnceBeforeUpdate();
                p._initOnceDone = true;
            }

            p.preUpdate();
        }

        if (Process.canRun(p))
        {
            for (child in p.children)
            {
                Process._doPreUpdate(child, p.utmod);
            }
        }
    }

    private static inline function _doMainUpdate(p: Process): Void
    {
        if (!Process.canRun(p)) return;

        p.update();

        if (p.onUpdateCb != null) p.onUpdateCb();

        if (Process.canRun(p))
        {
            for (child in p.children)
            {
                Process._doMainUpdate(child);
            }
        }
    }

    private static inline function _doFixedUpdate(p: Process): Void
    {
        if (!Process.canRun(p)) return;

        p.fixedUpdateAccumulator += p.tmod;

        while (p.fixedUpdateAccumulator >= p.getDefaultFrameRate() / FIXED_UPDATE_FPS)
        {
            p.fixedUpdateAccumulator -= p.getDefaultFrameRate() / FIXED_UPDATE_FPS;

            if (Process.canRun(p))
            {
                p.fixedUpdate();
                if (p.onFixedUpdateCb != null) p.onFixedUpdateCb();
            }
        }

        if (Process.canRun(p))
        {
            for (child in p.children)
            {
                Process._doFixedUpdate(child);
            }
        }
    }

    private static inline function _doPostUpdate(p: Process): Void
    {
        if (!Process.canRun(p)) return;

        p.postUpdate();

        if (!p.isDestroyed)
        {
            for (child in p.children)
            {
                Process._doPostUpdate(child);
            }
        }
    }

    private static function _garbageCollect(plist: ProcList): Void
    {
        var i = 0;
        var p: Process;

        #if unlimitedProcesses
            while (i < plist.length)
            {
                p = plist[i];

                if (p.isDestroyed) Process._disposeProcess(p);
                else Process._garbageCollect(p.children);
                i++;
            }
        #else
            while (i < plist.allocated)
            {
                p = plist.get(i);

                if (p.isDestroyed) Process._disposeProcess(p);
                else Process._garbageCollect(p.children);
                i++;
            }
        #end
    }

    private static function _disposeProcess(p: Process): Void
    {
        // Children
        for (child in p.children)
        {
            p.destroy();
        }

        Process._garbageCollect(p.children);

        // Unregister from lists
        if (p.parent != null) p.parent.children.remove(p);
        else ROOTS.remove(p);

        // Graphic content
        #if heaps
            p.root.remove();
        #end

        // Callbacks
        p.onDispose();
        if (p.onDisposeCb != null) p.onDisposeCb();

        // Tools

        // Cleanup
        p.parent = null;
        p.children = null;

        #if heaps
            p.root = null;
        #end
    }

    private static inline function _resizeProcess(p: Process): Void
    {
        if (!p.isDestroyed)
        {
            p.onResizeCb();
            p.onResize();
        }

        for (p in p.children) Process._resizeProcess(p);
    }


    // GAMEOBJECT API
    public dynamic function onUpdateCb(): Void {}
    public dynamic function onFixedUpdateCb(): Void {}
    public dynamic function onDisposeCb(): Void {}
    public dynamic function onResizeCb(): Void {}

    private function preUpdate(): Void {}
    private function update(): Void {}
    private function fixedUpdate(): Void {}
    private function postUpdate(): Void {}
    private function onDispose(): Void {}
    private function onResize(): Void {}


    // INSTANCE API

    /** Process display name **/
    public var name: Null<String>;

    #if unlimitedProcesses
        var children: Array<Process>;
    #else
        var children: FixedArray<Process>;
    #end

    public var uniqueId: Int;

    /** This `tmod` value is unaffected by the time multiplier **/
    public var utmod: Float;

    #if heaps
        public var root: Null<h2d.Layers>;
    #end

    /** Elapsed frames from the client start **/
    public var ftime(default, null): Float;

    /** Elapsed frames from the client start, as 32bits Int **/
    public var itime(get, never): Int;

    /** Elapsed seconds from the client start **/
    public var stime(get, never): Float;

    /** TRUE if process was marked for removal during GC phase. **/
    public var isDestroyed(default, null): Bool;

    /**
     * Time modifier
     *
     * = 1.0 if FPS is OK
     * > 1.0 if some frames were lost
     * < 1.0 if more frames are played than expected)
     */
    public var tmod(get, never): Float;

    /** Elapsed frames not affected by time multiplier **/
    public var uftime(default, null): Float;

    /** TRUE if this process was directly manually paused **/
    private var manuallyPaused: Bool;

    /** Set to TRUE for this Process to ignore existing time multipliers, e.g. UI components **/
    private var ignoreTimeMultipliers: Bool = false;

    private var baseTimeMultiplier: Float = 1.0;

    private var fixedUpdateAccumulator: Float = 0.0;

    private var cachedClassName: String;

    /** Optional parent process reference **/
    private var parent(default, null): Process;


    // CONSTRUCTOR & INIT

    public function new(?parent: Process)
    {
        this.init();

        if (parent == null) ROOTS.push(this);
        else parent.addChild(this);
    }

    public function init(): Void
    {
        this.uniqueId = UNIQ_ID++;

        #if unlimitedProcesses
            this.children = [];
        #else
            this.children = new FixedArray(MAX_PROCESSES);
        #end

        this.manuallyPaused = false;
        this.isDestroyed = false;

        this.ftime = 0;
        this.uftime = 0;
        this.utmod = 1;
        this.baseTimeMultiplier = 1;
    }

    #if heaps
    public function createRoot(?ctx: h2d.Object): Void
    {
        if (this.root != null) throw this + ": root already created!";

        if (ctx == null)
        {
            if (this.parent == null || this.parent.root == null)
                throw this + ": context required";
            ctx = parent.root;
        }

        this.root = new h2d.Layers(ctx);
        this.root.name = this.getDisplayName();
    }
    #end

    #if heaps
    public function createContextlessRoot(): Void
    {
        if (this.root != null) throw this + ": root already created!";

        this.root = new h2d.Layers();
        this.root.name = this.getDisplayName();
    }
    #end

    #if heaps
    public function createRootInLayers(ctx: h2d.Layers, layer: Int): Void
    {
        if (root != null) throw this + ": root already created!";

        this.root = new h2d.Layers();
        this.root.name = this.getDisplayName();
        ctx.add(this.root, layer);
    }
    #end

    private var _initOnceDone: Bool = false;
    private function initOnceBeforeUpdate() {}


    // PUBLIC METHODS

    public function isPaused(): Bool
    {
        if (this.manuallyPaused) return true;
        return this.anyParentPaused();
    }

    public function addChild(p: Process): Void
    {
        if (p.parent == null) ROOTS.remove(p);
        else p.parent.children.remove(p);

        p.parent = this;
        this.children.push(p);
    }

    public final inline function destroy(): Void
    {
        this.isDestroyed = true;
    }

    public inline function isRootProcess(): Bool
    {
        return this.parent == null;
    }

    public function moveChildToRootProcesses(p: Process): Void
    {
        if (p.parent != this) throw "Not a child of this process";
        p.parent = null;
        this.children.remove(p);
        ROOTS.push(p);
    }

    public function removeAndDestroyChild(p: Process): Void
    {
        if (p.parent != this) throw "Not a child of this process";
        p.parent = null;
        this.children.remove(p);
        ROOTS.push(p);  // for GC
        p.destroy();
    }

    public function createChildProcess(
        ?onUpdate: Process -> Void,
        ?onDispose: Process -> Void,
        ?runUpdateImmediately: Bool = false,
    ): Process {
        var p = new Process();

        if (onUpdate != null)
        {
            p.onUpdateCb = function() {
                onUpdate(p);
            }
        }

        if (onDispose != null)
        {
            p.onDisposeCb = function() {
                onDispose(p);
            }
        }

        if (runUpdateImmediately)
        {
            Process._doPreUpdate(p, 1.0);
            Process._doMainUpdate(p);
        }

        return p;
    }

    public function killAllChildrenProcesses(): Void
    {
        for (p in this.children) p.destroy();
    }

    public function pause(): Void
    {
        this.manuallyPaused = true;
    }

    public function resume(): Void
    {
        this.manuallyPaused = false;
    }

    public function togglePause(): Bool
    {
        if (this.manuallyPaused) this.resume();
        else this.pause();
        return this.manuallyPaused;
    }

    public function rndSign(): Int
    {
        return Std.random(2) * 2 - 1;
    }

    public function rndSecondsF(min: Float, max: Float, ?sign: Bool): Float
    {
        return this.secToFrames(MathLib.rnd(min, max, sign));
    }

    public function secToFrames(value: Float): Float
    {
        return value * this.getDefaultFrameRate();
    }

    public function framesToSec(value: Float): Float
    {
        return value / this.getDefaultFrameRate();
    }

    public function msToFrames(value: Float): Float
    {
        return (value / 1000) * this.getDefaultFrameRate();
    }

    public function framesToMs(value: Float): Float
    {
        return 1000 * value / this.getDefaultFrameRate();
    }

    public function setTimeMultiplier(value: Float): Void
    {
        this.baseTimeMultiplier = value;
    }

    public function getFixedUpdateAccumulatorRatio(): Float
    {
        return this.fixedUpdateAccumulator / (this.getDefaultFrameRate() / FIXED_UPDATE_FPS);
    }

    public function toString(): String
    {
        return '#$uniqueId ${this.getDisplayName()}${this.isPaused() ? " [PAUSED]" : ""}';
    }

    public function getDisplayName(): String
    {
        if (this.name != null) return this.name;

        if (this.cachedClassName == null)
        {
            this.cachedClassName = Type.getClassName(Type.getClass(this));
        }

        return this.cachedClassName;
    }


    // PRIVATE METHODS

    private function anyParentPaused(): Bool
    {
        return this.parent != null ? this.parent.isPaused() : false;
    }

    /** Get total time multiplier, including parent Processes **/
    private function getComputedTimeMultiplier(): Float
    {
        if (this.ignoreTimeMultipliers) return 1.0;
        var parentMul = this.parent == null ? 1 : this.parent.getComputedTimeMultiplier();
        return MathLib.fmax(0, this.baseTimeMultiplier * parentMul);
    }

    private function getDefaultFrameRate(): Int
    {
        #if heaps
            return MathLib.round(hxd.Timer.wantedFPS);
        #else
            return 60;
        #end
    }

    private function countChildren(): Int
    {
        #if unlimitedProcesses
            return this.children.length;
        #else
            return this.children.allocated;
        #end
    }

    private inline function emitResizeAtEndOfFrame(): Void
    {
        Process.resizeAll(false);
    }

    private inline function emitResizeNow(): Void
    {
        Process.resizeAll(true);
    }


    // GETTER IMPLEMENTATIONS

    private function get_itime(): Int
    {
        return Std.int(this.ftime);
    }

    private function get_stime(): Float
    {
        return this.ftime / this.getDefaultFrameRate();
    }

    private function get_tmod(): Float
    {
        return this.utmod * this.getComputedTimeMultiplier();
    }
}
