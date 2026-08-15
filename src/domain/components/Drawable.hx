package domain.components;

import common.struct.Coordinate;
import common.struct.FloatPoint;
import ecs.Component;
import engine.ColorKey;
import engine.RenderLayerManager;

abstract class Drawable extends Component {
	@save public var primary: ColorKey;
	@save public var secondary: ColorKey;
	@save public var outline: ColorKey = C_CLEAR;
	@save public var background: Null<ColorKey>;
	@save public var enableLutShader: Bool = true;

	@save public var layer(default, null): RenderLayerType;
	@save public var offsetX: Float = -8.0;
	@save public var offsetY: Float = -8.0;

	// World-space position to render at while easing toward a Move's goal.
	// Lets rendering lag behind the entity's logical `pos`, which snaps to
	// the goal immediately so gameplay systems never see a stale position.
	// The camera also tracks this (see AdventureScene.updateCamera) so it
	// follows the player smoothly during a move - only set this for actual
	// movement, not cosmetic nudges (see renderOffset for those).
	public var renderPos: Null<Coordinate> = null;

	// Pixel-space nudge applied on top of the normal render position, e.g.
	// easing a sprite toward a target during an attack lunge. Deliberately
	// separate from renderPos so cosmetic nudges like this don't drag the
	// camera along with them.
	public var renderOffset: Null<FloatPoint> = null;

	@save public var visible: Bool = false;
	@save public var isShrouded: Bool = false;

	// Lighting state. Recomputed every frame by VisionSystem/World, not persisted.
	public var isLit: Bool = false;
	public var lightColor: Int = 0;
	public var lightIntensity: Float = 0;

	public function new(
		primary: ColorKey = C_WHITE,
		secondary: ColorKey = C_CLEAR,
		background: ColorKey = C_SHROUD,
		layer: RenderLayerType = OBJECT,
	) {
		this.layer = layer;
		this.primary = primary;
		this.background = background;
		this.secondary = secondary;
	}
}
