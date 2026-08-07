package scenes.cursor;

import common.algorithm.Bresenham;
import engine.ColorKey;
import engine.Frame;
import engine.TileResources;
import h2d.Anim;
import h2d.Bitmap;
import scenes.cursor.CursorScene.CursorRenderOpts;
import shaders.SpriteShader;

class LookScene extends CursorScene {
	var ob: h2d.Object;
	var lineOb: h2d.Object;
	var targetBm: h2d.Bitmap;
	var targetShader: SpriteShader;
	var targetText: h2d.Text;

	public function new() {
		super();

		targetShader = new SpriteShader(C_YELLOW_HC);
		targetShader.ignoreLighting = 1;

		ob = new h2d.Object();
		lineOb = new h2d.Object(ob);
		targetBm = new Bitmap(TileResources.get(TK_LOOK_CURSOR), ob);
		targetBm.addShader(targetShader);

		renderText();
	}

	private override function onEnter() {
		super.onEnter();
		loop.render(OVERLAY, ob);
		loop.render(HUD, targetText);
	}

	private override function onDestroy() {
		ob.remove();
		targetText.remove();
	}

	private override function render(opts: CursorRenderOpts) {
		var end = opts.end.toPixel();

		if (end.x == targetBm.x && end.y == targetBm.y) {
			return;
		}

		targetBm.x = end.x;
		targetBm.y = end.y;
		targetBm.visible = true;
		lineOb.removeChildren();

		opts.line.each((p, idx) -> {
			if (idx == 0 || idx == opts.line.length - 1) {
				return;
			}

			var w = p.asWorld();
			var bm = new Bitmap(TileResources.get(TK_DOT), lineOb);
			var color = world.isVisible(w) ? C_YELLOW_HC : C_GRAY_1;
			var shader = new SpriteShader(color);

			shader.ignoreLighting = 1;
			bm.addShader(shader);
			var px = w.toPixel();
			bm.x = px.x;
			bm.y = px.y;
		});

		targetText.x = loop.window.width / 2;
		loop.camera.focus = world.player.pos;
	}

	private override function update(frame: Frame) {
		render({
			start: start,
			end: target,
			line: Bresenham.getLine(start.toIntPoint(), target.toIntPoint()),
		});

		world.systems.update(frame);

		if (world.systems.energy.isPlayersTurn) {
			var cmd = loop.commands.peek();
			if (cmd != null) {
				handle(loop.commands.next());
			}
		}
	}

	private function renderText() {
		targetText = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		targetText.color = C_WHITE.toHxdColor();
		targetText.y = 64;
		targetText.textAlign = Center;
	}
}
