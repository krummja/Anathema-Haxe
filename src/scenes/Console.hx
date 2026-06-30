package scenes;

import h2d.Tile;
import engine.Frame;
import engine.Scene;

class Console extends Scene {
	var root: h2d.Bitmap;

	public function new() {
		this.root = new h2d.Bitmap();
	}

	public override function onEnter() {
		root.addChild(loop.console);
		loop.render(HUD, root);
		loop.console.show();
	}

	public override function onDestroy() {
		loop.console.hide();
		root.removeChildren();
		root.remove();
	}

	public override function update(?frame: Frame) {
		root.tile = Tile.fromColor(0x1a1d22, loop.window.width, loop.window.height, 0.65);
		if (!loop.console.isActive()) {
			loop.console.show();
		}
	}
}
