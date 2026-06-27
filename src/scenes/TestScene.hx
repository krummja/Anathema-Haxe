package scenes;

import engine.MainLoop;
import engine.KeyCode;
import engine.Frame;
import engine.Scene;

class TestScene extends Scene {
	public function new() {}

	private override function onEnter(): Void {
		MainLoop.getInstance().world.initialize();
		MainLoop.getInstance().world.start();
	}

	private override function onDestroy(): Void {}

	private override function update(?frame: Frame): Void {
		MainLoop.getInstance().world.update();
		updateCamera();
	}

	private function updateCamera(): Void {
		var cfocus = loop.camera.focus.toWorld().toFloatPoint();
		var ctarget = loop.world.player.pos.toFloatPoint();
		loop.camera.focus = ctarget.asWorld();
		// loop.camera.focus = cfocus.lerp(ctarget, 0.2).asWorld();
	}
}
