package components;

import engine.RenderLayerManager;
import engine.TileResources;
import engine.ColorKey;
import engine.TileKey;
import common.struct.FloatPoint;
import h2d.Tile;
import h2d.Bitmap;

class Sprite extends Drawable {
	public var tileKey(default, set): TileKey;
	public var ob(default, null): Bitmap;
	public var tile(get, never): Tile;

	public function new(
		tileKey: TileKey,
		primary: ColorKey = C_WHITE,
		secondary: ColorKey = C_BLACK,
		layer: RenderLayerType = OBJECT,
	) {
		super(primary, secondary, layer);
		this.tileKey = tileKey;

		this.ob = new Bitmap(this.tile);
		this.ob.addShader(this.shader);
		this.ob.visible = true;
	}

	public function getPosition(): FloatPoint {
		return new FloatPoint(this.ob.x, this.ob.y);
	}

	public function setPosition(x: Float, y: Float): Void {
		this.ob.setPosition(x, y);
	}

	private function get_tile(): Tile {
		return TileResources.get(this.tileKey);
	}

	private function set_tileKey(value: TileKey): TileKey {
		this.tileKey = value;
		if (this.ob != null) this.ob.tile = this.tile;
		return value;
	}

	private function getDrawable(): h2d.Drawable {
		return this.ob;
	}
}
