package scenes.ui;

import engine.MainLoop;
import hxd.Window;

class UIManager {
	public var loop(get, never): MainLoop;
	public var window(get, never): Window;

	public var width(default, null): Int;
	public var height(default, null): Int;

	public function new() {
		window.addResizeEvent(onWindowResized);
	}

	public function fromLeftAnchor(width: Int): Int {
		return width;
	}

	public function fromTopAnchor(height: Int): Int {
		return height;
	}

	private function onWindowResized() {
		this.width = window.width;
		this.height = window.height;
	}

	private function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}

	private function get_window(): Window {
		return Window.getInstance();
	}
}
