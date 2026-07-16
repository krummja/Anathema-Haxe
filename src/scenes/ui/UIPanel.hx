package scenes.ui;

import engine.ColorKey;
import scenes.ui.RLay.UIColor;
import scenes.ui.RLay.Padding;
import engine.MainLoop;
import engine.Frame;
import scenes.ui.RLay.UIRect;
import h2d.Graphics;

typedef Updatable = {
	var ?x: Null<Float>;
	var ?y: Null<Float>;
	var ?width: Null<Float>;
	var ?height: Null<Float>;
	var ?padding: Null<Int>;
	var ?paddingType: Null<Padding>;
}

class UIPanel {
	public var onUpdate: (Frame) -> Void;

	public var x(get, null): Float;
	public var y(get, null): Float;
	public var width(get, null): Float;
	public var height(get, null): Float;

	@:allow(engine.Scene)
	private var rlay: RLay;

	@:allow(engine.Scene)
	private var rect: UIRect;

	private var graphics: Graphics;

	public function new(x: Float, y: Float, width: Float, height: Float, ?bg: ColorKey) {
		this.rlay = new RLay();

		this.rlay.initUIColors(
			C_WHITE,
			bg.or(C_RED_4),
			C_RED_0,
			C_RED_3,
			C_GREEN_0,
		);

		this.rect = {
			maxx: width,
			maxy: height,
			minx: x,
			miny: y,
		};

		this.graphics = new Graphics();
		MainLoop.getInstance().render(HUD, this.graphics);
	}

	public function draw() {
		rlay.uiRectToGraphics(rect, graphics);
	}

	public function update(frame: Frame) {
		if (this.onUpdate != null) {
			this.onUpdate(frame);
		}
		draw();
	}

	// public function onUpdate(frame: Frame) {}

	public function remove() {
		this.graphics.remove();
		this.rlay = null;
		this.rect = null;
	}

	private function get_x(): Float {
		return this.rect.minx;
	}

	private function get_y(): Float {
		return this.rect.miny;
	}

	private function get_width(): Float {
		return Math.max(0, this.rect.maxx - this.rect.minx);
	}

	private function get_height(): Float {
		return Math.max(0, this.rect.maxy - this.rect.miny);
	}
}
