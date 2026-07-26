package engine;

import domain.World;
import common.struct.Coordinate;
import hxd.Window;

class Camera {
	public var x(get, set): Float;
	public var y(get, set): Float;
	public var pos(get, set): Coordinate;

	public var width(get, null): Float;
	public var height(get, null): Float;
	public var zoom(get, set): Float;
	public var focus(get, set): Coordinate;

	public var world(get, never): World;
	public var scroller(get, null): h2d.Object;

	/**
	 * Fraction of the window reserved for the gameplay view. The remainder
	 * is left for UI panels (see adventure.xml's side/bottom wrappers).
	 */
	public var viewportRatioX: Float = 0.7;

	public var viewportRatioY: Float = 0.8;

	/**
	 * Where within the gameplay viewport the focus point sits on screen,
	 * as a fraction of viewportWidth/viewportHeight (0.5 = centered).
	 */
	public var anchorX: Float = 0.5;

	public var anchorY: Float = 0.5;

	public var clampX: Bool = true;
	public var clampY: Bool = true;

	/**
	 * Size of the gameplay viewport in pixels, derived from viewportRatioX/Y.
	 * This is the single source of truth for how much of the window is
	 * actually rendering the world, vs. reserved for UI panels.
	 */
	public var viewportWidth(get, never): Float;

	public var viewportHeight(get, never): Float;

	private var loop(get, never): MainLoop;

	private var viewportWorldWidth(get, never): Float;
	private var viewportWorldHeight(get, never): Float;

	/**
	 * On-screen pixel sizes a 16x16 (UNIT_X/UNIT_Y) tile is allowed to
	 * render at. Zoom always snaps to one of these so every tile edge
	 * lands on an integer pixel boundary instead of shimmering/seaming
	 * under fractional scaling.
	 */
	private static var ZOOM_STEPS: Array<Int> = [4, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 48, 56, 64, 80, 96, 112, 128];

	/**
	 * Hard ceiling on zoom, expressed as an on-screen tile size multiplier
	 * (e.g. 8.0 = tiles never render larger than 128px).
	 */
	public var maxZoom: Float = 8.0;

	private var zoomIndex: Int = 0;

	public function new() {
		zoom = 1.0;

		// Re-clamp zoom whenever the window resizes; the min/max bounds are
		// derived from viewportWidth/Height, which change with it.
		Window.getInstance().addResizeEvent(() -> zoom = zoom);
	}

	private inline function get_width(): Float {
		return Window.getInstance().width;
	}

	private inline function get_height(): Float {
		return Window.getInstance().height;
	}

	private function set_zoom(value: Float): Float {
		zoomIndex = clampZoomIndex(nearestZoomStepIndex(value * loop.UNIT_X));
		var snapped = ZOOM_STEPS[zoomIndex] / loop.UNIT_X;
		scroller.setScale(snapped);
		return snapped;
	}

	private function get_zoom(): Float {
		return scroller.scaleX;
	}

	private function nearestZoomStepIndex(tileSize: Float): Int {
		var bestIndex = 0;
		var bestDiff = Math.POSITIVE_INFINITY;
		for (i in 0...ZOOM_STEPS.length) {
			var diff = Math.abs(ZOOM_STEPS[i] - tileSize);
			if (diff < bestDiff) {
				bestDiff = diff;
				bestIndex = i;
			}
		}
		return bestIndex;
	}

	/**
	 * Smallest on-screen tile size (in pixels) that still keeps the current
	 * zone at least as large as the viewport in both axes. Zero (no limit)
	 * until the world is available, since the camera is constructed first.
	 */
	private function minZoomTileSize(): Float {
		if (world == null) {
			return 0;
		}

		var minX = viewportWidth / world.zoneWidth;
		var minY = viewportHeight / world.zoneHeight;
		return Math.max(minX, minY);
	}

	/**
	 * Clamps a zoom step index so it can never zoom out past minZoomTileSize
	 * nor zoom in past maxZoom.
	 */
	private function clampZoomIndex(index: Int): Int {
		var minTileSize = minZoomTileSize();
		var maxTileSize = maxZoom * loop.UNIT_X;

		var minIndex = 0;
		while (minIndex < ZOOM_STEPS.length - 1 && ZOOM_STEPS[minIndex] < minTileSize) {
			minIndex++;
		}

		var maxIndex = ZOOM_STEPS.length - 1;
		while (maxIndex > 0 && ZOOM_STEPS[maxIndex] > maxTileSize) {
			maxIndex--;
		}

		return Std.int(Math.max(minIndex, Math.min(maxIndex, index)));
	}

	/**
	 * Steps zoom in to the next larger clean tile size.
	 */
	public function zoomIn(): Float {
		return zoom = ZOOM_STEPS[Std.int(Math.min(zoomIndex + 1, ZOOM_STEPS.length - 1))] / loop.UNIT_X;
	}

	/**
	 * Steps zoom out to the next smaller clean tile size.
	 */
	public function zoomOut(): Float {
		return zoom = ZOOM_STEPS[Std.int(Math.max(zoomIndex - 1, 0))] / loop.UNIT_X;
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

	private function get_viewportWidth(): Float {
		return width * viewportRatioX;
	}

	private function get_viewportHeight(): Float {
		return height * viewportRatioY;
	}

	private function get_viewportWorldWidth(): Float {
		return viewportWidth / (loop.UNIT_X * zoom);
	}

	private function get_viewportWorldHeight(): Float {
		return viewportHeight / (loop.UNIT_Y * zoom);
	}

	/**
	 * Sets camera scroller x position. Converts unit to pixel space.
	 */
	private function set_x(value: Float): Float {
		if (clampX) {
			var maxX = Math.max(0, world.zoneWidth - viewportWorldWidth);
			value = Math.min(Math.max(value, 0), maxX);
		}

		var p = Projection.worldToPixel(value, y);
		scroller.x = -(p.x * zoom);

		return value;
	}

	/**
	 * Sets camera scroller y position. Converts unit to pixel space.
	 */
	private function set_y(value: Float): Float {
		if (clampY) {
			var maxY = Math.max(0, world.zoneHeight - viewportWorldHeight);
			value = Math.min(Math.max(value, 0), maxY);
		}

		var p = Projection.worldToPixel(x, value);
		scroller.y = -(p.y * zoom);

		return value;
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

	/**
	 * Moves the camera so that the given world point appears at the anchor
	 * point on screen (viewportWidth * anchorX, viewportHeight * anchorY).
	 */
	private function set_focus(value: Coordinate): Coordinate {
		var w = value.toWorld();
		this.x = w.x - (viewportWidth * anchorX) / (loop.UNIT_X * zoom);
		this.y = w.y - (viewportHeight * anchorY) / (loop.UNIT_Y * zoom);
		return this.pos;
	}

	/**
	 * Screen-space anchor point that the camera is currently focused on.
	 */
	private function get_focus(): Coordinate {
		return new Coordinate(viewportWidth * anchorX, viewportHeight * anchorY, SCREEN);
	}

	private function get_scroller(): h2d.Object {
		return MainLoop.getInstance().layers.scroller;
	}

	private function get_world(): World {
		return MainLoop.getInstance().world;
	}

	private function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}
}
