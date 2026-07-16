package scenes.ui;

import h2d.Graphics;
import common.struct.Size;
import common.struct.IntPoint;
import common.struct.Rect;
import h3d.Vector4;
import engine.ColorKey;

typedef UIRect = {
	var minx: Float;
	var miny: Float;
	var maxx: Float;
	var maxy: Float;
}

enum UIColor {
	Background;
	Primary;
	Secondary;
	Accent;
	Raised;
	Sunken;
}

enum TextAlign {
	Left;
	Center;
	Right;
}

enum Padding {
	Top;
	Bottom;
	Left;
	Right;
	All;
}

enum TextColor {
	Main;
	Muted;
	Dim;
}

typedef ColorUI = {
	var text: Vector4;
	var background: Vector4;
	var primary: Vector4;
	var secondary: Vector4;
	var accent: Vector4;

	var bgRaised: Vector4;
	var bgSunken: Vector4;
	var textMuted: Vector4;
	var textDim: Vector4;
}

class RLay {
	public var colorUI: ColorUI;

	public function new() {
		colorUI = {
			text: C_WHITE.toHxdColor(),
			background: C_SHROUD.toHxdColor(),
			primary: C_RED_0.toHxdColor(),
			secondary: C_RED_3.toHxdColor(),
			accent: C_GREEN_0.toHxdColor(),
			bgRaised: C_BLACK.toHxdColor(),
			bgSunken: C_GRAY_6.toHxdColor(),
			textMuted: C_GRAY_1.toHxdColor(),
			textDim: C_GRAY_3.toHxdColor(),
		};
	}

	public function getTextColor(color: TextColor): Vector4 {
		switch (color) {
			case Main:
				return colorUI.text;
			case Muted:
				return colorUI.textMuted;
			case Dim:
				return colorUI.textDim;
		}
	}

	public function getUIColor(role: UIColor): Vector4 {
		switch (role) {
			case Background:
				return colorUI.background;
			case Primary:
				return colorUI.primary;
			case Secondary:
				return colorUI.secondary;
			case Accent:
				return colorUI.accent;
			case Raised:
				return colorUI.bgRaised;
			case Sunken:
				return colorUI.bgSunken;
		}
	}

	public function withAlpha(color: Vector4, alpha: Int): Vector4 {
		var r = color.r;
		var g = color.g;
		var b = color.b;
		return new Vector4(r, g, b, alpha / 255);
	}

	public function colorShift(color: Vector4, amount: Int): Vector4 {
		return new Vector4(
			(color.r + amount / 255).clamp(0, 1),
			(color.g + amount / 255).clamp(0, 1),
			(color.b + amount / 255).clamp(0, 1),
			color.a,
		);
	}

	public function initUIColors(
		text: ColorKey,
		background: ColorKey,
		primary: ColorKey,
		secondary: ColorKey,
		accent: ColorKey
	) {
		colorUI.text = text.toHxdColor();
		colorUI.background = background.toHxdColor();
		colorUI.primary = primary.toHxdColor();
		colorUI.secondary = secondary.toHxdColor();
		colorUI.accent = accent.toHxdColor();
		colorUI.bgRaised = colorShift(background.toHxdColor(), 12);
		colorUI.bgSunken = colorShift(background.toHxdColor(), -12);
		colorUI.textMuted = withAlpha(text.toHxdColor(), 140);
		colorUI.textDim = withAlpha(text.toHxdColor(), 76);
	}

	public function cutLeft(rect: UIRect, a: Float): UIRect {
		var minx = rect.minx;
		rect.minx = Math.min(rect.maxx, rect.minx + a);
		return {
			maxx: minx,
			maxy: rect.miny,
			minx: rect.minx,
			miny: rect.maxy
		};
	}

	public function cutRight(rect: UIRect, a: Float): UIRect {
		var maxx = rect.maxx;
		rect.maxx = Math.max(rect.minx, rect.maxx - a);
		return {
			maxx: rect.maxx,
			maxy: rect.miny,
			minx: maxx,
			miny: rect.maxy,
		};
	}

	public function cutTop(rect: UIRect, a: Float): UIRect {
		var miny = rect.miny;
		rect.miny = Math.min(rect.maxy, rect.miny + a);
		return {
			maxx: rect.minx,
			maxy: miny,
			minx: rect.maxx,
			miny: rect.miny,
		};
	}

	public function cutBottom(rect: UIRect, a: Float): UIRect {
		var maxy = rect.maxy;
		rect.maxy = Math.max(rect.miny, rect.maxy - a);
		return {
			maxx: rect.minx,
			maxy: rect.maxy,
			minx: rect.maxx,
			miny: maxy,
		};
	}

	public function cutLeftPercent(rect: UIRect, percent: Float): UIRect {
		var a = (rect.maxx - rect.minx) * percent;
		var minx = rect.minx;
		rect.minx = Math.min(rect.maxx, rect.minx + a);
		return {
			maxx: minx,
			maxy: rect.miny,
			minx: rect.minx,
			miny: rect.maxy,
		};
	}

	public function cutRightPercent(rect: UIRect, percent: Float): UIRect {
		var a = (rect.maxx - rect.minx) * percent;
		var maxx = rect.maxx;
		rect.maxx = Math.max(rect.minx, rect.maxx + a);
		return {
			maxx: rect.maxx,
			maxy: rect.miny,
			minx: maxx,
			miny: rect.maxy,
		};
	}

	public function cutTopPercent(rect: UIRect, percent: Float): UIRect {
		var a = (rect.maxy - rect.miny) * percent;
		var miny = rect.miny;
		rect.miny = Math.min(rect.maxy, rect.miny + a);
		return {
			maxx: rect.minx,
			maxy: miny,
			minx: rect.maxx,
			miny: rect.miny,
		};
	}

	public function cutBottomPercent(rect: UIRect, percent: Float): UIRect {
		var a = (rect.maxy - rect.miny) * percent;
		var maxy = rect.maxy;
		rect.maxy = Math.max(rect.miny, rect.maxy + a);
		return {
			maxx: rect.minx,
			maxy: rect.maxy,
			minx: rect.maxx,
			miny: maxy,
		};
	}

	public function cutMultipleTopPercent(rect: UIRect, percents: Array<Float>): Array<UIRect> {
		return cutMultiplePercent(rect, percents, getTotalRectHeight, cutTop);
	}

	public function cutMultipleBottomPercent(rect: UIRect, percents: Array<Float>): Array<UIRect> {
		return cutMultiplePercent(rect, percents, getTotalRectHeight, cutBottom);
	}

	public function cutMultipleLeftPercent(rect: UIRect, percents: Array<Float>): Array<UIRect> {
		return cutMultiplePercent(rect, percents, getTotalRectWidth, cutLeft);
	}

	public function cutMultipleRightPercent(rect: UIRect, percents: Array<Float>): Array<UIRect> {
		return cutMultiplePercent(rect, percents, getTotalRectWidth, cutRight);
	}

	public function cutMultipleEvenlyHeight(rect: UIRect, pieces: Int): Array<UIRect> {
		var result = [];
		var totalHeight = getTotalRectHeight(rect);
		var heightPiece = totalHeight / pieces;

		for (i in 0...pieces) {
			result[i] = cutTop(rect, heightPiece);
		}

		return result;
	}

	public function cutMultipleEvenlyWidth(rect: UIRect, pieces: Int): Array<UIRect> {
		var result = [];
		var totalWidth = getTotalRectWidth(rect);
		var widthPiece = totalWidth / pieces;

		for (i in 0...pieces) {
			result[i] = cutLeft(rect, widthPiece);
		}

		return result;
	}

	public function cutRectEvenly(rect: UIRect, lenCol: Int): Array<UIRect> {
		var result = [];

		var rows = cutMultipleEvenlyHeight(rect, lenCol);

		var i = 0;
		for (row in rows) {
			var cols = cutMultipleEvenlyWidth(row, lenCol);
			for (col in cols) {
				result[i] = col;
				i++;
			}
		}

		return result;
	}

	public function addPadding(rect: UIRect, padding: Int, paddingType: Padding): UIRect {
		switch (paddingType) {
			case All:
				rect.minx += padding;
				rect.miny += padding;
				rect.maxx -= padding;
				rect.maxy -= padding;
			case Top:
				rect.miny += padding;
			case Bottom:
				rect.maxy -= padding;
			case Left:
				rect.minx += padding;
			case Right:
				rect.maxx -= padding;
		}
		return rect;
	}

	public function uiRectToRect(rect: UIRect): Rect {
		var width = Math.max(0, rect.maxx - rect.minx);
		var height = Math.max(0, rect.maxy - rect.miny);
		return new Rect(
			new IntPoint(rect.minx.floor(), rect.miny.floor()),
			new Size(width.floor(), height.floor()),
		);
	}

	public function uiRectToGraphics(rect: UIRect, ?graphics: Null<Graphics>): Graphics {
		if (graphics != null) {
			graphics.clear();
		} else {
			graphics = new Graphics();
		}

		var width = Math.max(0, rect.maxx - rect.minx);
		var height = Math.max(0, rect.maxy - rect.miny);
		graphics.beginFill(getUIColor(Background).toColor());
		graphics.drawRect(rect.minx, rect.miny, width, height);
		graphics.endFill();
		return graphics;
	}

	private function cutMultiplePercent(
		rect: UIRect,
		percents: Array<Float>,
		getDimension: (UIRect) -> Float,
		cut: (UIRect, Float) -> UIRect
	): Array<UIRect> {
		var result = [];
		var total = getDimension(rect);

		for (i => p in percents) {
			result[i] = cut(rect, total * p);
		}

		return result;
	}

	private function getTotalRectWidth(rect: UIRect): Float {
		return Math.max(0, rect.maxx - rect.minx);
	}

	private function getTotalRectHeight(rect: UIRect): Float {
		return Math.max(0, rect.maxx - rect.miny);
	}
}
