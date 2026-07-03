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
		loop.setWorld(new World());
		loop.world.initialize();

		var seed = Std.random(0xffffff);
		loop.world.start(seed);

		loop.scenes.set(new TestScene());
	}
}
