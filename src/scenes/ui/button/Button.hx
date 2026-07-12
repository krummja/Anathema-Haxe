package scenes.ui.button;

import engine.ColorKey;
import h2d.Bitmap;
import h2d.Tile;
import h2d.Interactive;
import engine.Scene;
import scenes.ui.label.Label;

class Button extends Scene {
	private var buttonOb: Bitmap;
	private var label: Label;

	public function new(settings: LabelSettings) {
		buttonOb = new Bitmap(Tile.fromColor(C_RED_3.toHxdColor().toColor()));
		buttonOb.x = settings.pos.x;
		buttonOb.y = settings.pos.y;

		var tw = loop.UNIT_X * 2;
		var th = loop.UNIT_Y * 2;

		var fontHeight = 16;
		var fontOffset = ((th - fontHeight) / 2).floor();

		buttonOb.width = 64;
		buttonOb.height = 16;

		loop.render(HUD, buttonOb);

		label = new Label(settings);

		label.pos = {x: settings.pos.x + (buttonOb.width / 2), y: label.pos.y};

		// var interactive = new Interactive()
	}

	@:allow(engine.Scene)
	private function remove() {
		label.remove();
		buttonOb.remove();
	}
}
