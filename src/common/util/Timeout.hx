package common.util;

import engine.MainLoop;

class Timeout {
	public var name(default, null): String;
	public var duration(default, null): Float;
	public var start(default, null): Float;
	public var isComplete(default, null): Bool;
	public var progress(get, null): Float;
	public var interruptible(default, null): Bool;

	private var now(get, never): Float;

	public function new(seconds: Float, name: String, interruptible: Bool = true) {
		this.duration = seconds;
		this.name = name;
		this.interruptible = interruptible;

		this.start = this.now;
		this.isComplete = false;
	}

	public dynamic function onComplete() {}

	public function reset(): Void {
		this.start = this.now;
		this.isComplete = false;
	}

	public function stop(): Void {
		this.isComplete = true;
	}

	public function update(): Void {
		if (!this.isComplete && (this.now - this.start) > this.duration) {
			this.isComplete = true;
			this.onComplete();
		}
	}

	private inline function get_now(): Float {
		return MainLoop.getInstance().frame.elapsed;
	}

	private function get_progress(): Float {
		return ((this.now - this.start) / this.duration).clamp(0, 1);
	}

	public function toString(): String {
		return 'Timeout ${name}: ${progress}/${duration} (${isComplete ? "Finished" : "Running"})';
	}
}
