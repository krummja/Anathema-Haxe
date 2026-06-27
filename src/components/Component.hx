package components;

import engine.EntityEvent;

abstract class Component {
	private var handlers: Map<String, (evt: EntityEvent) -> Void> = new Map();

	private function addHandler<T: EntityEvent>(type: Class<T>, fn: (T) -> Void) {
		var className = Type.getClassName(type);
		handlers.set(className, cast fn);
	}

	private function onEvent(evt: EntityEvent) {
		var cls = Type.getClass(evt);
		var className = Type.getClassName(cls);
		var handler = handlers.get(className);

		if (handler != null) {
			handler(evt);
		}
	}
}
