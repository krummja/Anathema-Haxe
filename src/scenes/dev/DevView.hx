package scenes.dev;

import engine.Scene;
import haxe.ui.containers.Box;
import haxe.ui.containers.windows.WindowManager;

@:build(haxe.ui.macros.ComponentMacros.build("./xml/dev.xml"))
class DevView extends Box {
	private var scene: Scene;

	public function new(scene: Scene) {
		super();

		WindowManager.instance.container = windowContainer;

		this.scene = scene;
		this.scene.loop.render(HUD, this);

		WindowManager.instance.addWindow(new SimpleWindow());
	}
}
