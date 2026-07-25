package engine;

class Viewport {
	public var nativeCamera(get, never): h2d.Camera;

	public var viewportX(get, set): Float;
	public var viewportY(get, set): Float;
	public var viewportWidth(get, set): Float;
	public var viewportHeight(get, set): Float;
	public var anchorX(get, set): Float;
	public var anchorY(get, set): Float;
	public var clip(get, set): Bool;

	public function new() {}

	private function get_nativeCamera(): h2d.Camera {
		return MainLoop.getInstance().app.s2d.camera;
	}

	private function get_viewportX(): Float {
		return nativeCamera.viewportX;
	}

	private function set_viewportX(value: Float) {
		nativeCamera.viewportX = value;
		return value;
	}

	private function get_viewportY(): Float {
		return nativeCamera.viewportY;
	}

	private function set_viewportY(value: Float) {
		nativeCamera.viewportY = value;
		return value;
	}

	private function get_viewportWidth(): Float {
		return nativeCamera.viewportWidth;
	}

	private function set_viewportWidth(value: Float) {
		nativeCamera.viewportWidth = value;
		return value;
	}

	private function get_viewportHeight(): Float {
		return nativeCamera.viewportHeight;
	}

	private function set_viewportHeight(value: Float) {
		nativeCamera.viewportHeight = value;
		return value;
	}

	private function get_anchorX(): Float {
		return nativeCamera.anchorX;
	}

	private function set_anchorX(value: Float) {
		nativeCamera.anchorX = value;
		return value;
	}

	private function get_anchorY(): Float {
		return nativeCamera.anchorY;
	}

	private function set_anchorY(value: Float) {
		nativeCamera.anchorY = value;
		return value;
	}

	private function get_clip(): Bool {
		return nativeCamera.clipViewport;
	}

	private function set_clip(value: Bool): Bool {
		nativeCamera.clipViewport = value;
		return value;
	}
}
