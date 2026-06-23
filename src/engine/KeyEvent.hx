package engine;

enum KeyEventType {
	KEY_UP;
	KEY_DOWN;
}

@:structInit class KeyEvent {
	public var type: KeyEventType;
	public var key: KeyCode;
	public var shift: Bool;
	public var ctrl: Bool;
	public var alt: Bool;

	public function debugKey(): String {
		var val = "";

		if (shift) val += "shift+";
		if (ctrl) val += "ctrl+";
		if (alt) val += "alt+";

		val += key.toChar();

		val += type == KEY_UP ? ' (up)' : ' (down)';

		return val;
	}
}
