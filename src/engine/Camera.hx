package engine;

import common.struct.Coordinate;
import hxd.Window;

class Camera {
	/**
	 * Camera's x position in pixel space
	 */
	public var x(get, set): Float;

	/**
	 * Camera's y position in pixel space
	 */
	public var y(get, set): Float;

	/**
	 * Camera's position in world space
	 */
	public var pos(get, set): Coordinate;

	public var offsetX(default, null): Float;
	public var offsetY(default, null): Float;

	public var width(get, null): Float;
	public var height(get, null): Float;
	public var focus(get, set): Coordinate;
	public var zoom(get, set): Float;
	public var windowColumns(default, set): Int;

	public var scroller(get, null): h2d.Object;

	public function new() {
		zoom = 1.0;
		offsetX = 0.3;
		offsetY = 0.5;
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

	/**
	 * Sets camera x position. Converts unit to pixel space.
	 * Additionally sets the scroller's x position.
	 */
	private function set_x(value: Float): Float {
		if (value < 0) {
			value = 0;
		}

		var world = MainLoop.getInstance().world;
		var zoneWidth = world.zoneWidth;
		var viewCols = (width / world.loop.UNIT_X).floor();

		var offsetCols = (focus.x / world.loop.UNIT_X).floor();
		var maxX = (zoneWidth - ((viewCols - offsetCols) / zoom));

		if (value >= maxX) {
			value = maxX;
		}

		var p = Projection.worldToPixel(value, y);
		scroller.x = -((p.x + 0.5) * zoom);
		return p.x;
	}

	/**
	 * Sets camera y position. Converts unit to pixel space.
	 * Additionally sets the scroller's y position.
	 */
	private function set_y(value: Float): Float {
		if (value < 0) {
			value = 0;
		}

		var world = MainLoop.getInstance().world;
		var zoneHeight = world.zoneHeight;
		var viewRows = (height / world.loop.UNIT_Y).floor();
		var maxY = zoneHeight - (viewRows / zoom);

		if (value >= maxY) {
			value = maxY;
		}

		var p = Projection.worldToPixel(x, value);
		scroller.y = -((p.y + 0.5) * zoom);
		return p.y;
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

	private function get_scroller(): h2d.Object {
		return MainLoop.getInstance().layers.scroller;
	}

	private function set_windowColumns(value: Int): Int {
		this.windowColumns = value;
		return value;
	}
}
