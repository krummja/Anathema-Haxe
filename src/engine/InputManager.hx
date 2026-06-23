package engine;

import engine.KeyEvent.KeyEventType;
import common.struct.Queue;

class InputManager {
	public var queue: Queue<KeyEvent>;
	// public var mouse: Coordinate;
	public var modShift: Bool = false;
	public var modCtrl: Bool = false;
	public var modAlt: Bool = false;

	public function new() {
		this.queue = new Queue(4);
		// this.mouse = new Coordinate(0, 0, SCREEN);
		MainLoop.getInstance().window.addEventTarget(this.onSceneEvent);
	}

	public inline function next(): Null<KeyEvent> {
		return queue.dequeue();
	}

	public inline function peek(): Null<KeyEvent> {
		return queue.peek();
	}

	public inline function hasNext(): Bool {
		return !queue.isEmpty;
	}

	public function flush() {
		queue.flush();
	}

	private function handleKeyEvent(key: KeyCode, type: KeyEventType) {
		var event: KeyEvent = {
			key: key,
			type: type,
			shift: modShift,
			ctrl: modCtrl,
			alt: modAlt,
		};

		this.queue.enqueue(event);
	}

	private function setModKeys(key: KeyCode, type: KeyEventType) {
		switch (key) {
			case KEY_SHIFT:
				modShift = type == KEY_DOWN;
			case KEY_CONTROL:
				modCtrl = type == KEY_DOWN;
			case KEY_ALT:
				modAlt = type == KEY_DOWN;
			case _:
		}
	}

	private function onSceneEvent(event: hxd.Event): Void {
		switch (event.kind) {
			case EKeyUp:
				this.setModKeys(event.keyCode, KEY_UP);
			case EKeyDown:
				this.setModKeys(event.keyCode, KEY_DOWN);
				this.handleKeyEvent(event.keyCode, KEY_DOWN);
			case _:
		}
	}
}
