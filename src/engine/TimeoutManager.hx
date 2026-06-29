package engine;

import common.util.Timeout;

class TimeoutManager {
	public var timeouts(default, null): Map<String, Timeout>;

	public function new() {
		timeouts = new Map();
	}

	public function start(name: String, duration: Float, interruptible: Bool = true): Timeout {
		if (timeouts.exists(name)) {
			if (timeouts[name].interruptible) {
				timeouts[name].reset();
			}
		} else {
			var timeout = new Timeout(duration, name, interruptible);
			timeout.onComplete = () -> {
				this.timeouts.remove(name);
			}

			this.timeouts[name] = timeout;
		}

		return this.timeouts[name];
	}

	public function get(name: String): Timeout {
		return this.timeouts.get(name);
	}

	public function update() {
		for (timeout in timeouts) {
			timeout.update();
		}
	}

	public function metrics() {
		for (timeout in timeouts) {
			trace(timeout.toString());
		}
	}
}
