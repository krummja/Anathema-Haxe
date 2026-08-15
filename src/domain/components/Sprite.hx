package domain.components;

import engine.RenderLayerManager;
import engine.ColorKey;
import engine.TileKey;

class Sprite extends Drawable {
	@save public var tileKey: TileKey;

	public function new(
		tileKey: TileKey,
		primary: ColorKey = C_WHITE,
		secondary: ColorKey = C_BLACK,
		layer: RenderLayerType = OBJECT,
	) {
		super(primary, secondary, layer);
		this.tileKey = tileKey;
	}
}
