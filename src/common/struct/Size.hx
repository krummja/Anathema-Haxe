package common.struct;

@:structInit
class Size {
	public final w: Int;
	public final h: Int;

	public var area(get, never): Float;

	public function new(w: Int, h: Int) {
		this.w = w;
		this.h = h;
	}

	public overload extern inline function add(other: Size): Size {
		return new Size(w + other.w, h + other.h);
	}

	public overload extern inline function add(n: Int): Size {
		return new Size(w + n, h + n);
	}

	public overload extern inline function sub(other: Size): Size {
		return new Size(w - other.w, h - other.h);
	}

	public overload extern inline function sub(n: Int): Size {
		return new Size(w - n, h - n);
	}

	public function floorDiv(n: Int): Size {
		return new Size((w / n).floor(), (h / n).floor());
	}

	private function get_area(): Float {
		return w * h;
	}
}
