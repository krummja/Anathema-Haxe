package common.struct;

import h2d.col.Point;

@:structInit
class Rect {
	public static function fromEdges(top: Int, bottom: Int, left: Int, right: Int): Rect {
		return new Rect(new IntPoint(left, top), new Size(right - left + 1, bottom - top + 1));
	}

	public static function fromSpans(vertical: Span, horizontal: Span): Rect {
		return Rect.fromEdges(vertical.start.y, vertical.end.y, horizontal.start.x, horizontal.end.x);
	}

	public static function centeredAt(size: Size, center: IntPoint): Rect {
		var left = center.x - (size.w / 2).floor();
		var top = center.y - (size.h / 2).floor();
		return new Rect(new IntPoint(left, top), size);
	}

	public var origin(default, null): IntPoint;
	public var size(default, null): Size;

	public var top(get, never): Int;
	public var bottom(get, never): Int;
	public var left(get, never): Int;
	public var right(get, never): Int;
	public var topLeft(get, never): IntPoint;
	public var topRight(get, never): IntPoint;
	public var bottomLeft(get, never): IntPoint;
	public var bottomRight(get, never): IntPoint;
	public var area(get, never): Float;
	public var center(get, never): IntPoint;
	public var verticalSpan(get, never): Span;
	public var horizontalSpan(get, never): Span;

	public var x(get, set): Int;
	public var y(get, set): Int;
	public var x2(get, never): Int;
	public var y2(get, never): Int;
	public var width(get, set): Int;
	public var height(get, set): Int;

	public function new(origin: IntPoint, size: Size) {
		this.origin = origin;
		this.size = size;
	}

	public overload extern inline function contains(point: IntPoint): Bool {
		return left <= point.x && point.x <= right && top <= point.y && point.y <= bottom;
	}

	public overload extern inline function contains(rect: Rect): Bool {
		return top < rect.top && bottom > rect.bottom && left < rect.left && right > rect.right;
	}

	/**
	 * Copy this Rect with the given origin.
	 */
	public function withOrigin(newOrigin: IntPoint): Rect {
		return new Rect(newOrigin, size);
	}

	/**
	 * Copy this Rect with the given size.
	 */
	public function withSize(newSize: Size): Rect {
		return new Rect(origin, newSize);
	}

	/**
	 * Find a point x% across the width and y% across the height.
	 * @param relWidth Float between 0 and 1.
	 * @param relHeight Float between 0 and 1.
	 * @return IntPoint
	 */
	public function relativePoint(relWidth: Float, relHeight: Float): IntPoint {
		var rw = relWidth.clamp(0, 1);
		var rh = relHeight.clamp(0, 1);
		return new IntPoint(
			left + ((width - 1) * rw + 0.5).floor(),
			top + ((height - 1) * rh + 0.5).floor(),
		);
	}

	public function innerPoints(): Array<IntPoint> {
		var points = [];

		for (x in (left + 1)...(right - 1)) {
			for (y in (top + 1)...(bottom - 1)) {
				points.push(new IntPoint(x, y));
			}
		}

		return points;
	}

	public function allPoints(): Array<IntPoint> {
		var points = [];

		for (x in (left)...(right)) {
			for (y in (top)...(bottom)) {
				points.push(new IntPoint(x, y));
			}
		}

		return points;
	}

	public function pointsTop(): Array<IntPoint> {
		var start = origin.x + 1;
		var end = origin.x + width - 1;
		return [for (x in start...end) new IntPoint(x, origin.y)];
	}

	public function pointsBottom(): Array<IntPoint> {
		var start = origin.x + 1;
		var end = origin.x + width - 1;
		return [for (x in start...end) new IntPoint(x, origin.y + height - 1)];
	}

	public function pointsLeft(): Array<IntPoint> {
		var start = origin.y + 1;
		var end = origin.y + height - 1;
		return [for (y in start...end) new IntPoint(origin.x, y)];
	}

	public function pointsRight(): Array<IntPoint> {
		var start = origin.y + 1;
		var end = origin.y + height - 1;
		return [for (y in start...end) new IntPoint(origin.x + width - 1, y)];
	}

	public function pointsCorners(): Array<IntPoint> {
		return [
			origin,
			topRight,
			bottomRight,
			bottomLeft,
		];
	}

	public function distanceTo(other: Rect): Float {
		return (Math.abs(other.center.x - center.x) + Math.abs(other.center.y - center.y));
	}

	public function iterBorder(): Iterator<IntPoint> {
		var points = [];

		for (x in (left + 1)...right) {
			points.push(new IntPoint(x, top));
			points.push(new IntPoint(x, bottom));
		}

		for (y in (top + 1)...bottom) {
			points.push(new IntPoint(left, y));
			points.push(new IntPoint(right, y));
		}

		points.push(new IntPoint(left, top));
		points.push(new IntPoint(right, top));
		points.push(new IntPoint(left, bottom));
		points.push(new IntPoint(right, bottom));

		return points.iterator();
	}

	public function iterBorderDirections(): Iterator<{p: IntPoint, d: Cardinal}> {
		var points: Array<{p: IntPoint, d: Cardinal}> = [];

		for (x in (left + 1)...right) {
			points.push({p: new IntPoint(x, top), d: NORTH});
			points.push({p: new IntPoint(x, bottom), d: SOUTH});
		}

		for (y in (top + 1)...bottom) {
			points.push({p: new IntPoint(left, y), d: WEST});
			points.push({p: new IntPoint(right, y), d: EAST});
		}

		points.push({p: new IntPoint(left, top), d: NORTH_WEST});
		points.push({p: new IntPoint(right, top), d: NORTH_EAST});
		points.push({p: new IntPoint(left, bottom), d: SOUTH_WEST});
		points.push({p: new IntPoint(right, bottom), d: SOUTH_EAST});

		return points.iterator();
	}

	public function iterPoints(): Iterator<IntPoint> {
		var points = [];

		for (x in left...(right + 1)) {
			for (y in top...(bottom + 1)) {
				points.push(new IntPoint(x, y));
			}
		}

		return points.iterator();
	}

	private function get_top(): Int {
		return origin.y;
	}

	private function get_bottom(): Int {
		return origin.y + size.h;
	}

	private function get_left(): Int {
		return origin.x;
	}

	private function get_right(): Int {
		return origin.x + size.w;
	}

	private function get_topLeft(): IntPoint {
		return origin;
	}

	private function get_topRight(): IntPoint {
		return new IntPoint(origin.x + width - 1, origin.y);
	}

	private function get_bottomLeft(): IntPoint {
		return new IntPoint(origin.x, origin.y + height - 1);
	}

	private function get_bottomRight(): IntPoint {
		return origin.add(size.w, size.h).sub(1);
	}

	private function get_area(): Float {
		return size.area;
	}

	private function get_center(): IntPoint {
		return relativePoint(0.5, 0.5);
	}

	private function get_horizontalSpan(): Span {
		return new Span(new IntPoint(left, top), new IntPoint(right, top));
	}

	private function get_verticalSpan(): Span {
		return new Span(new IntPoint(left, top), new IntPoint(left, bottom));
	}

	private function get_x(): Int {
		return origin.x;
	}

	private function set_x(value: Int): Int {
		origin = new IntPoint(value, y);
		return value;
	}

	private function get_y(): Int {
		return origin.y;
	}

	private function set_y(value: Int): Int {
		origin = new IntPoint(x, value);
		return value;
	}

	private function get_x2(): Int {
		return origin.x + size.w - 1;
	}

	private function get_y2(): Int {
		return origin.y + size.h - 1;
	}

	private function get_width(): Int {
		return size.w;
	}

	private function set_width(value: Int): Int {
		size = new Size(value, height);
		return value;
	}

	private function get_height(): Int {
		return size.h;
	}

	private function set_height(value: Int): Int {
		size = new Size(width, value);
		return value;
	}
}
