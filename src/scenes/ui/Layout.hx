package scenes.ui;

import Type.ValueType;
import haxe.exceptions.ArgumentException;
import common.struct.Size;
import common.struct.IntPoint;
import common.struct.Rect;

typedef LayoutSettings = {
	var ?width: Null<String>;
	var ?height: Null<String>;
	var ?left: Null<String>;
	var ?top: Null<String>;
	var ?right: Null<String>;
	var ?bottom: Null<String>;
}

enum LayoutType {
	Undefined;
	None;
	Frame;
	Intrinsic;
	Constant;
	Fraction;
}

class Layout {
	public static var VALUE_MIN = -10_000;
	public static var VALUE_MAX = 10_000;
	public static var ZERO_RECT = new Rect(new IntPoint(0, 0), new Size(0, 0));

	public static function centered(width: String, height: String) {
		return new Layout({
			width: width,
			height: height,
		});
	}

	public static function columnLeft(width: String) {
		return new Layout({
			top: "0",
			bottom: "0",
			left: "0",
			width: width,
		});
	}

	public static function columnRight(width: String) {
		return new Layout({
			top: "0",
			bottom: "0",
			right: "0",
			width: width,
		});
	}

	public static function rowTop(height: String) {
		return new Layout({
			top: "0",
			left: "0",
			right: "0",
			height: height,
		});
	}

	public static function rowBottom(height: String) {
		return new Layout({
			bottom: "0",
			left: "0",
			right: "0",
			height: height,
		});
	}

	public var width(default, null): Null<String>;
	public var height(default, null): Null<String>;
	public var left(default, null): Null<String>;
	public var top(default, null): Null<String>;
	public var right(default, null): Null<String>;
	public var bottom(default, null): Null<String>;

	private var settings: LayoutSettings;

	public function new(settings: LayoutSettings) {
		this.width = settings.width;
		this.height = settings.height;
		this.left = settings.left;
		this.top = settings.top;
		this.right = settings.right;
		this.bottom = settings.bottom;

		this.settings = settings;
	}

	public function withUpdates(updated: LayoutSettings) {
		return new Layout({
			width: updated.width.or(this.settings.width),
			height: updated.height.or(this.settings.height),
			top: updated.top.or(this.settings.top),
			bottom: updated.bottom.or(this.settings.bottom),
			left: updated.left.or(this.settings.left),
			right: updated.right.or(this.settings.right),
		});
	}

	public function getValue(field: String, view: View): Null<Dynamic> {
		// No resolvable value for field
		if (Type.typeof(field) == null) {
			trace('Superview isn\'t relevant to this value');
		}
		// Constant field returns the field value directly
		else if (getType(field) == Constant) {
			return Reflect.field(this, field);
		}
		// Intrinsic value returns either width or height
		else if (getType(field) == Intrinsic) {
			if (field == "width") {
				return view.intrinsicSize.w;
			} else if (field == "height") {
				return view.intrinsicSize.h;
			} else {
				throw new ArgumentException("Intrinsic can only be used with width or height");
			}
		}
		// Frame value returns top, left, bottom, right, width or height values
		else if (getType(field) == Frame) {
			if (field == "left") {
				return view.layoutSpec.x;
			} else if (field == "top") {
				return view.layoutSpec.y;
			} else if (field == "right") {
				return view.superview.bounds.width - view.layoutSpec.right;
			} else if (field == "bottom") {
				return view.superview.bounds.height - view.superview.layoutSpec.bottom;
			} else if (field == "width") {
				return view.layoutSpec.width;
			} else if (field == "height") {
				return view.layoutSpec.height;
			} else {
				throw new ArgumentException('Unknown key $field');
			}
		}
		// Fraction value returns fractional value of specified field
		else if (getType(field) == Fraction) {
			var val = Reflect.field(this, field);
			if (field == "left" || field == "width" || field == "right") {
				return view.superview.bounds.width * val;
			} else if (field == "top" || field == "height" || field == "bottom") {
				return view.superview.bounds.height * val;
			} else {
				throw new ArgumentException('Unknown key $field');
			}
		}

		return null;
	}

	public function isDefined(field: String): Bool {
		return Reflect.field(this, field) != null;
	}

	/**
	 * For a given defined key, resolve the layout type and return the value of that key
	 * in that layout schema.
	 */
	private function getType(field: String): LayoutType {
		var value = Reflect.field(this, field);
		var type = Type.typeof(field);

		if (value == null) {
			return None;
		} else if (value == "frame") {
			return Frame;
		} else if (value == "intrinsic") {
			return Intrinsic;
		} else {
			switch (type) {
				case TClass(String):
					if (Std.parseFloat(value) >= 1) {
						// Whole numbers greater than 1
						return Constant;
					} else {
						// Decimal values between 0.0 and 0.99
						return Fraction;
					}
				case _:
					trace('Unknown type for option $field: $type');
					return Undefined;
			}
		}

		trace('Unknown type for option $field: $type');
		return Undefined;
	}
}
