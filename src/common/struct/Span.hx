package common.struct;

@:structInit
class Span {
	public final start: IntPoint;
	public final end: IntPoint;

	public function new(start: IntPoint, end: IntPoint) {
		this.start = start;
		this.end = end;
	}

	public function contains(point: IntPoint): Bool {
		return start.lessOrEquals(point) && end.lessOrEquals(point);
	}

	public function overlaps(other: Span): Bool {
		return start.lessOrEquals(other.end) && other.start.lessOrEquals(end);
	}

	public function length(): Int {
		return Math.sqrt((end.x - (start.x + 1)).pow(2) + (end.y - (start.y + 1)).pow(2)).floor();
	}

	public overload extern inline function add(n: Int): Span {
		return new Span(start.add(n), end.add(n));
	}

	public overload extern inline function sub(n: Int): Span {
		return new Span(start.sub(n), end.sub(n));
	}

	public function iterator(): Iterator<IntPoint> {
		var points = [];

		for (x in start.x...(end.x + 1)) {
			for (y in start.y...(end.y + 1)) {
				points.push(new IntPoint(x, y));
			}
		}

		return points.iterator();
	}
}
