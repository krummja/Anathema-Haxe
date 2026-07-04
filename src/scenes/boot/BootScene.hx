package scenes.boot;

import scenes.test.TestScene;
import domain.World;
import engine.KeyCode;
import engine.Scene;

class BootScene extends Scene {
	public function new() {}

	public override function onKeyDown(key: KeyCode) {
		if (key == KEY_SPACE) {
			start();
		}
	}

	public function start() {
		var seed = Std.random(0xffffff);
		loop.files.deleteSave("test");
		loop.files.setSaveName("test");
		loop.setWorld(new World());
		loop.world.initialize();
		loop.world.start(seed);
		loop.scenes.set(new TestScene());
	}
}
