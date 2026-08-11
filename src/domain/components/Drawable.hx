package domain.components;

import common.struct.Coordinate;
import ecs.Component;
import engine.ColorKey;
import engine.RenderLayerManager;
import engine.SpriteView;

abstract class Drawable extends Component {
	@save public var primary(default, set): ColorKey;
	@save public var secondary(default, set): ColorKey;
	@save public var outline(default, set): ColorKey;
	@save public var background(default, set): Null<ColorKey>;
	@save public var enableLutShader(default, set): Bool = true;

	@save public var layer(default, null): RenderLayerType;
	@save public var offsetX(default, set): Float = -8.0;
	@save public var offsetY(default, set): Float = -8.0;

	// World-space position to render at while easing toward a Move's goal.
	// Lets rendering lag behind the entity's logical `pos`, which snaps to
	// the goal immediately so gameplay systems never see a stale position.
	public var renderPos: Null<Coordinate> = null;

	@save public var visible(default, set): Bool = false;
	@save public var isShrouded(default, set): Bool = false;

	public var primaryColor(default, never): ColorKey;
	public var secondaryColor(get, never): ColorKey;
	public var drawable(get, never): h2d.Drawable;
	public var shader(get, never): shaders.SpriteShader;

	// Owns the actual Heaps rendering objects; subclasses attach a tile to it
	// once they know one (see engine.SpriteView).
	public var view(default, null): SpriteView;

	public function new(
		primary: ColorKey = C_WHITE,
		secondary: ColorKey = C_CLEAR,
		background: ColorKey = C_SHROUD,
		layer: RenderLayerType = OBJECT,
	) {
		this.view = new SpriteView();
		this.layer = layer;
		this.primary = primary;
		this.background = background;
		this.secondary = secondary;
	}

	public function updatePosition(px: Float, py: Float): Void {
		this.drawable.x = px;
		this.drawable.y = py;
	}

	private function set_primary(value: ColorKey): ColorKey {
		this.primary = value;
		this.view.shader.primary = value.toHxdColor().toVector();
		return value;
	}

	private function set_secondary(value: ColorKey): ColorKey {
		this.secondary = value;
		this.view.shader.secondary = value.toHxdColor().toVector();
		return value;
	}

	private function set_outline(value: ColorKey): ColorKey {
		this.outline = value;
		this.view.shader.outline = value.toHxdColor().toVector();
		return value;
	}

	private function set_background(value: Null<ColorKey>): Null<ColorKey> {
		this.background = value;
		var clear = value != null;
		if (clear) this.view.shader.background = value.toHxdColor().toVector();
		this.view.shader.clearBackground = clear ? 1 : 0;
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
		return this.view.drawable;
	}

	private function get_shader(): shaders.SpriteShader {
		return this.view.shader;
	}

	private function set_visible(value: Bool): Bool {
		this.visible = value;
		return this.drawable.visible = value;
	}

	private function set_isShrouded(value: Bool): Bool {
		isShrouded = value;
		view.shader.setShrouded(value);
		return value;
	}

	private function set_enableLutShader(value: Bool): Bool {
		enableLutShader = value;
		return value;
	}
}
