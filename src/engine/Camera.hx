package engine;

import domain.World;
import common.struct.Coordinate;
import hxd.Window;

class Camera {
	public var x(get, set): Float;
	public var y(get, set): Float;
	public var pos(get, set): Coordinate;
	public var offsetX(get, set): Float;
	public var offsetY(default, null): Float;

	public var width(get, null): Float;
	public var height(get, null): Float;
	public var zoom(get, set): Float;
	public var focus(get, set): Coordinate;

	public var viewport(default, null): Viewport;
	public var world(get, never): World;
	public var windowColumns(default, set): Int;
	public var scroller(get, null): h2d.Object;

	public var viewportW(get, never): Float;
	public var viewportH(get, never): Float;

	private var _offsetX: Float = 0.0;
	private var _clampX: Bool = true;
	private var _clampY: Bool = true;

	public function new() {
		zoom = 1.0;
		offsetX = 0.35;
		offsetY = 0.4;
		viewport = new Viewport();
	}

	private inline function get_width(): Float {
		return Window.getInstance().width;
	}

	private inline function get_height(): Float {
		return Window.getInstance().height;
	}

	private function set_zoom(value: Float): Float {
		scroller.setScale(Math.max(value, 0.1));
		return value;
	}

	private function get_zoom(): Float {
		return scroller.scaleX;
	}

	/**
	 * Set camera position. Converts coordinate unit to world space.
	 * Additionally sets the x and y values of the camera.
	 */
	private function set_pos(value: Coordinate): Coordinate {
		var w = value.toWorld();
		x = w.x;
		y = w.y;
		return w;
	}

	/**
	 * Camera position in world space.
	 */
	private function get_pos(): Coordinate {
		return new Coordinate(x, y, WORLD);
	}

	private function get_viewportW(): Float {
		var loop = MainLoop.getInstance();
		return (width * offsetX) / loop.UNIT_X;
	}

	private function get_viewportH(): Float {
		var loop = MainLoop.getInstance();
		return (height * offsetY) / loop.UNIT_Y;
	}

	/**
	 * Sets camera scroller x position. Converts unit to pixel space.
	 */
	private function set_x(value: Float): Float {
		if (value <= 0) {
			value = 0;
		}

		if (value >= world.zoneWidth - viewportW) {
			value = world.zoneWidth - viewportW;
		}

		var p = Projection.worldToPixel(value, y);
		scroller.x = -((p.x + 0.5) * zoom);
		return scroller.x;
	}

	/**
	 * Sets camera scroller y position. Converts unit to pixel space.
	 */
	private function set_y(value: Float): Float {
		if (value <= 0) {
			value = 0;
		}

		if (value >= world.zoneHeight - viewportH) {
			value = world.zoneHeight - viewportH;
		}

		var p = Projection.worldToPixel(x, value);
		scroller.y = -((p.y + 0.5) * zoom);
		return scroller.y;
	}

	/**
	 * Camera's x position in world space, derived from the scroller's pixel x value.
	 */
	private function get_x(): Float {
		var c = Projection.pixelToWorld(-scroller.x / zoom, -scroller.y / zoom);
		return c.x;
	}

	/**
	 * Camera's y position in world space, derived from the scroller's pixel y value.
	 */
	private function get_y(): Float {
		var c = Projection.pixelToWorld(-scroller.x / zoom, -scroller.y / zoom);
		return c.y;
	}

	private function set_focus(value: Coordinate): Coordinate {
		var screenMid = new Coordinate(width * offsetX, height * offsetY, SCREEN);
		this.pos = value.sub(screenMid).add(this.pos);
		return this.pos;
	}

	private function get_focus(): Coordinate {
		return new Coordinate(width * offsetX, height * offsetY, SCREEN);
	}

	private function get_offsetX(): Float {
		return _offsetX;
	}

	private function set_offsetX(value: Float): Float {
		_offsetX = value;
		return value;
	}

	private function set_windowColumns(value: Int): Int {
		this.windowColumns = value;
		return value;
	}

	private function get_scroller(): h2d.Object {
		return MainLoop.getInstance().layers.scroller;
	}

	private function get_world(): World {
		return MainLoop.getInstance().world;
	}
}
