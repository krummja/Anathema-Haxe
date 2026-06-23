package components;

import shaders.SpriteShader;
import engine.RenderLayerManager;
import engine.ColorKey;

abstract class Drawable {
	public var primary(default, set): ColorKey;
	public var secondary(default, set): ColorKey;
	public var outline(default, set): ColorKey;
	public var background(default, set): Null<ColorKey>;

	public var layer(default, null): RenderLayerType;
	public var primaryColor(default, never): ColorKey;
	public var secondaryColor(get, never): ColorKey;
	public var drawable(get, never): h2d.Drawable;
	public var shader(default, null): SpriteShader;
	public var visible(default, set): Bool;

	public var offsetX(default, set): Float = -8.0;
	public var offsetY(default, set): Float = -8.0;

	public function new(
		primary: ColorKey = C_WHITE,
		secondary: ColorKey = C_CLEAR,
		layer: RenderLayerType = OBJECT,
	) {
		this.shader = new SpriteShader();
		this.layer = layer;
		this.primary = primary;
		this.secondary = secondary;
	}

	public function updatePosition(px: Float, py: Float): Void {
		this.drawable.x = px;
		this.drawable.y = py;
	}

	private abstract function getDrawable(): h2d.Drawable;

	private function set_primary(value: ColorKey): ColorKey {
		this.primary = value;
		this.shader.primary = value.toHxdColor().toVector();
		return value;
	}

	private function set_secondary(value: ColorKey): ColorKey {
		this.secondary = value;
		this.shader.secondary = value.toHxdColor().toVector();
		return value;
	}

	private function set_outline(value: ColorKey): ColorKey {
		this.outline = value;
		this.shader.outline = value.toHxdColor().toVector();
		return value;
	}

	private function set_background(value: Null<ColorKey>): Null<ColorKey> {
		this.background = value;
		var clear = value != null;
		if (clear) this.shader.background = value.toHxdColor().toVector();
		this.shader.clearBackground = clear ? 1 : 0;
		return value;
	}

	private function set_offsetX(value: Float): Float {
		this.offsetX = value;
		this.drawable.x += this.offsetX;
		this.drawable.x -= value;
		return value;
	}

	private function set_offsetY(value: Float): Float {
		this.offsetY = value;
		this.drawable.y += this.offsetY;
		this.drawable.y -= value;
		return value;
	}

	private function get_primaryColor(): ColorKey {
		return this.primary;
	}

	private function get_secondaryColor(): ColorKey {
		return this.secondary;
	}

	private function get_drawable(): h2d.Drawable {
		return this.getDrawable();
	}

	private function set_visible(value: Bool): Bool {
		this.drawable.visible = value;
		return value;
	}
}
