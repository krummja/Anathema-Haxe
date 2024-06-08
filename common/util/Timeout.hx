package common.util;

import core.MainLoop;


class Timeout
{
    public var duration(default, null): Float;
    public var start(default, null): Float;
    public var isComplete(default, null): Bool;
    public var progress(get, null): Float;

    private var now(get, never): Float;

    public function new(seconds: Float)
    {
        this.duration = seconds;
        this.start = this.now;
        this.isComplete = false;
    }

    public dynamic function onComplete() {}

    public function reset(): Void
    {
        this.start = this.now;
        this.isComplete = false;
    }

    public function stop(): Void
    {
        this.isComplete = true;
    }

    public function update(): Void
    {
        if (!this.isComplete && (this.now - this.start) > this.duration)
        {
            this.isComplete = true;
            this.onComplete();
        }
    }

    private inline function get_now(): Float
    {
        return MainLoop.instance.frame.elapsed;
    }

    private function get_progress(): Float
    {
        return ((this.now - this.start) / this.duration).clamp(0, 1);
    }
}
