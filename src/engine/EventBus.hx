package engine;

import haxe.Constraints.Function;

class EventBus<EventType: String> {
	public var events: Map<EventType, EventBase<Any>>;

	public function new() {
		events = new Map();
	}

	@:generic
	public function createEvent<V: Any>(name: EventType, ?event: EventBase<V>): Void {
		event = event == null ? new Event() : event;
		events.set(name, event);
	}

	public function removeEvent(name: EventType) {
		events.remove(name);
	}

	public function addEventListener(name: EventType, call: Function) {
		events.get(name).addListener(call);
	}

	public function removeListener(name: EventType, call: Function) {
		events.get(name).removeListener(call);
	}

	public function callEvent(name: EventType, ?options: Dynamic): Bool {
		var event = events.get(name);

		if (event == null) {
			return false;
		}

		event.call(options);
		return true;
	}
}
