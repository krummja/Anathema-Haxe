package scenes.mainmenu;

import scenes.ui.UIPanel;
import scenes.ui.RLay;
import domain.World;
import h3d.Vector4;
import common.struct.Coordinate;
import common.util.Timeout;
import engine.Frame;
import engine.KeyCode;
import engine.Scene;
import scenes.test.TestScene;
import scenes.ui.label.Label;

class MainMenuScene extends Scene {
	private var title: Label;
	private var next: Label;
	private var timeout: Timeout;

	private var panel: UIPanel;
	private var panel2: UIPanel;

	public function new() {
		timeout = new Timeout(3, "mainmenu");
	}

	public override function onEnter() {
		title = new Label({
			content: "Anathema",
			fontScale: 6,
			fontColor: new Vector4(1, 1, 0.9, 1),
			pos: {x: camera.width / 2, y: camera.height / 2}
		});

		next = new Label({
			content: "click anywhere to continue",
			fontColor: new Vector4(1, 1, 0.9, 1),
			pos: {x: camera.width / 2, y: camera.height / 2 + 128},
		});

		panel = new UIPanel(0, 0, loop.camera.width, loop.camera.height);
		panel2 = new UIPanel(0, 0, loop.camera.width, loop.camera.height, C_RED_2);

		panel.onUpdate = function(frame: Frame) {
			panel.rect = {
				minx: 0,
				miny: 0,
				maxx: loop.camera.width,
				maxy: loop.camera.height,
			};

			panel.rect = panel.rlay.addPadding(panel.rect, 16, All);
		}

		panel2.onUpdate = function(frame: Frame) {
			panel2.rect = {
				minx: 0,
				miny: 0,
				maxx: loop.camera.width,
				maxy: loop.camera.height,
			};

			panel2.rect = panel2.rlay.addPadding(panel2.rect, 24, All);
		}
	}

	public override function update(frame: Frame) {
		timeout.update();

		title.pos = {x: camera.width / 2, y: camera.height / 2};
		next.pos = {x: camera.width / 2, y: camera.height / 2 + 128};

		panel.update(frame);
		panel2.update(frame);
	}

	public override function onMouseUp(pos: Coordinate) {
		okay();
	}

	public override function onKeyDown(key: KeyCode) {
		okay();
	}

	public override function onDestroy() {
		title.remove();
		next.remove();
		panel.remove();
		panel2.remove();
	}

	private function okay() {
		var seed = Std.random(0xffffff);
		loop.files.deleteSave("test");
		loop.files.setSaveName("test");
		loop.setWorld(new World());
		loop.world.initialize();
		loop.world.start(seed);
		loop.scenes.set(new TestScene());
	}
}
