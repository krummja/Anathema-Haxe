package scenes.ui;

import engine.Scene;
import h2d.Object;
import common.struct.FloatPoint;

class UIComponent extends Scene {
	public var pos(get, set): FloatPoint;
	public var scale(get, set): Float;

	private var root: Object;

	public function new() {
		root = new Object();
	}

	public function remove() {
		root.remove();
	}

	private function get_pos(): FloatPoint {
		return {x: root.x, y: root.y};
	}

	private function set_pos(value: FloatPoint): FloatPoint {
		root.x = value.x;
		root.y = value.y;
		return value;
	}

	private function get_scale(): Float {
		return root.scaleX;
	}

	private function set_scale(value: Float): Float {
		root.setScale(value);
		return value;
	}
}
