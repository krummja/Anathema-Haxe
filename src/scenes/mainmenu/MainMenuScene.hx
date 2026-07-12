package scenes.mainmenu;

import engine.TextResources;
import h2d.Text;
import scenes.ui.UIComponent;
import domain.World;
import h3d.Vector4;
import common.struct.Coordinate;
import common.util.Timeout;
import engine.Frame;
import engine.KeyCode;
import engine.Scene;
import scenes.test.TestScene;
import scenes.ui.button.Button;
import scenes.ui.label.Label;

class MainMenuScene extends Scene {
	private var title: Label;
	private var next: Label;
	private var button: Button;
	private var timeout: Timeout;

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

		button = new Button({
			content: "Test",
			pos: {x: 256, y: 256},
		});
	}

	public override function update(frame: Frame) {
		timeout.update();

		title.pos = {x: camera.width / 2, y: camera.height / 2};
		next.pos = {x: camera.width / 2, y: camera.height / 2 + 128};
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
		button.remove();
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
