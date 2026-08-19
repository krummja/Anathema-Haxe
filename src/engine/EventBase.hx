package engine;

import haxe.Constraints.Function;

class EventBase<Options = Any> {
	public var listeners: Array<Function>;

	public function new() {
		listeners = [];
	}

	public function addListener(listener: Function) {
		listeners.push(listener);
	}

	public function removeListener(listener: Function) {
		listeners.remove(listener);
	}

	public function call(?options: Options) {
		var i = -1;
		while (listeners[++i] != null) {
			listeners[i](options);
		}
	}
}
