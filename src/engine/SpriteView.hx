package engine;

import shaders.SpriteShader;

/**
 * Owns the actual Heaps rendering objects (Bitmap + shader) for a
 * domain.components.Sprite. Constructed by domain.systems.SpriteSystem in
 * response to Sprite components being added/removed, and kept in sync with
 * the component's data every frame via `sync`/`setPosition` - the shader and
 * h2d types never need to be visible outside this class and SpriteSystem.
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

	public function setPosition(x: Float, y: Float): Void {
		this.ob.setPosition(x, y);
	}

	/**
	 * Pushes a Sprite's plain data fields into the shader/Bitmap. Colors are
	 * passed as ColorKey/Int and converted to Heaps color vectors internally.
	 */
	public function sync(
		primary: ColorKey,
		secondary: ColorKey,
		outline: ColorKey,
		background: Null<ColorKey>,
		isShrouded: Bool,
		isLit: Bool,
		lightColor: Int,
		lightIntensity: Float,
		visible: Bool
	): Void {
		shader.primary = primary.toHxdColor().toVector();
		shader.secondary = secondary.toHxdColor().toVector();
		shader.outline = outline.toHxdColor().toVector();

		var hasBackground = background != null;
		if (hasBackground) {
			shader.background = background.toHxdColor().toVector();
		}
		shader.clearBackground = hasBackground ? 1 : 0;

		shader.setShrouded(isShrouded);
		shader.isLit = isLit ? 1 : 0;
		shader.lightColor = lightColor.toHxdColor().toVector();
		shader.lightIntensity = lightIntensity;

		ob.visible = visible;
	}

	private function get_drawable(): h2d.Drawable {
		return this.ob;
	}
}
