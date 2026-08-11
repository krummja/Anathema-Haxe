package engine;

import common.struct.FloatPoint;
import shaders.SpriteShader;

/**
 * Owns the actual Heaps rendering objects (Bitmap + shader) behind a
 * domain.components.Drawable/Sprite. Constructed in two phases to match the
 * base/subclass split in Drawable/Sprite: the shader exists immediately (so
 * Drawable's color setters have somewhere to push to), the Bitmap is attached
 * once a concrete tile is known.
 */
class SpriteView {
	public var shader(default, null): SpriteShader;
	public var ob(default, null): h2d.Bitmap;
	public var drawable(get, never): h2d.Drawable;

	public function new() {
		this.shader = new SpriteShader();
	}

	public function attachTile(tile: h2d.Tile): Void {
		this.ob = new h2d.Bitmap(tile);
		this.ob.addShader(this.shader);
		this.ob.visible = false;
	}

	public function setTile(tile: h2d.Tile): Void {
		if (this.ob != null) {
			this.ob.tile = tile;
		}
	}

	public function getPosition(): FloatPoint {
		return new FloatPoint(this.ob.x, this.ob.y);
	}

	public function setPosition(x: Float, y: Float): Void {
		this.ob.setPosition(x, y);
	}

	private function get_drawable(): h2d.Drawable {
		return this.ob;
	}
}
