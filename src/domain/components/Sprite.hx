package domain.components;

import engine.RenderLayerManager;
import engine.TileResources;
import engine.ColorKey;
import engine.TileKey;
import common.struct.Coordinate;
import common.struct.FloatPoint;

class Sprite extends Drawable {
	@save public var tileKey(default, set): TileKey;

	public function new(
		tileKey: TileKey,
		primary: ColorKey = C_WHITE,
		secondary: ColorKey = C_BLACK,
		layer: RenderLayerType = OBJECT,
	) {
		super(primary, secondary, layer);
		this.tileKey = tileKey;
		this.view.attachTile(TileResources.get(tileKey));
	}

	public function getPosition(): FloatPoint {
		return view.getPosition();
	}

	public function setPosition(x: Float, y: Float): Void {
		view.setPosition(x, y);
	}

	public function setOffset(x: Float, y: Float): Void {
		view.setPosition(x, y);
	}

	/**
	 * Nudges this sprite's rendered position toward `value` in world space,
	 * while leaving the owning entity's logical `pos` untouched. Used to let
	 * rendering lag behind or ease ahead of gameplay position (e.g. attack lunges).
	 */
	public function offsetTo(value: Null<Coordinate>): Void {
		var delta = new Coordinate(0, 0, WORLD);

		if (value != null) {
			delta = value.sub(entity.pos).toPixel();
		}

		var startPos = getPosition();
		setPosition(startPos.x + delta.x, startPos.y + delta.y);
	}

	private function set_tileKey(value: TileKey): TileKey {
		this.tileKey = value;
		view.setTile(TileResources.get(value));
		return value;
	}
}
