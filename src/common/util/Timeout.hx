package common.util;

import engine.MainLoop;

class Timeout {
	public var name(default, null): String;
	public var duration(default, null): Float;
	public var start(default, null): Float;
	public var isComplete(default, null): Bool;
	public var progress(get, null): Float;
	public var inverted(default, null): Bool;
	public var interruptible(default, null): Bool;
	public var isPlaying(get, never): Bool;

	private var now(get, never): Float;

	public function new(seconds: Float, name: String, inverted: Bool = false, interruptible: Bool = true) {
		this.duration = seconds;
		this.name = name;
		this.inverted = inverted;
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
		if (inverted) {
			if (!this.isComplete && progress <= 0) {
				this.isComplete = true;
				this.onComplete();
			}
		} else {
			if (!this.isComplete && progress >= 1) {
				this.isComplete = true;
				this.onComplete();
			}
		}
	}

	private inline function get_now(): Float {
		return MainLoop.getInstance().frame.elapsed;
	}

	private function get_progress(): Float {
		var value = ((this.now - this.start) / this.duration);

		if (inverted) {
			return 1 - value.clamp(0, 1);
		}

		return value.clamp(0, 1);
	}

	private function get_isPlaying(): Bool {
		return progress <= duration && isComplete == false;
	}

	public function toString(): String {
		return 'Timeout ${name}: ${progress}/${duration} (${isComplete ? "Finished" : "Running"})';
	}
}
