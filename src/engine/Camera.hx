package engine;

import common.struct.Coordinate;
import hxd.Window;

class Camera {
	public var width(get, null): Float;
	public var height(get, null): Float;
	public var zoom(get, set): Float;
	public var pos(get, set): Coordinate;
	public var x(get, set): Float;
	public var y(get, set): Float;
	public var focus(get, set): Coordinate;
	public var offsetX(default, null): Int = 8;

	public var scroller(get, null): h2d.Object;

	public function new() {
		zoom = 1.0;
	}

	private inline function get_width(): Float {
		return Window.getInstance().width;
	}

	private inline function get_height(): Float {
		return Window.getInstance().height;
	}

	private function set_zoom(value: Float): Float {
		scroller.setScale(value);
		return value;
	}

	private function get_zoom(): Float {
		return scroller.scaleX;
	}

	private function set_pos(value: Coordinate): Coordinate {
		var w = value.toWorld();
		x = w.x;
		y = w.y;
		return w;
	}

	private function get_pos(): Coordinate {
		return new Coordinate(x, y, WORLD);
	}

	private function set_x(value: Float): Float {
		// `value` is the world x value (i.e. in tile units)

		var p = Projection.worldToPixel(value, y);
		scroller.x = -((p.x + 0.5) * zoom);
		return value;
	}

	private function set_y(value: Float): Float {
		var p = Projection.worldToPixel(x, value);

		scroller.y = -((p.y + 0.5) * zoom);

		return value;
	}

	private function get_x(): Float {
		var c = Projection.pixelToWorld(-scroller.x / zoom, -scroller.y / zoom);
		return c.x;
	}

	private function get_y(): Float {
		var c = Projection.pixelToWorld(-scroller.x / zoom, -scroller.y / zoom);
		return c.y;
	}

	private function set_focus(value: Coordinate): Coordinate {
		var screenMid = new Coordinate(width / 2, height / 2, SCREEN);
		this.pos = value.sub(screenMid).add(this.pos);
		return this.pos;
	}

	private function get_focus(): Coordinate {
		return new Coordinate(width / 2, height / 2, SCREEN);
	}

	private function get_scroller(): h2d.Object {
		return MainLoop.getInstance().layers.scroller;
	}
}
