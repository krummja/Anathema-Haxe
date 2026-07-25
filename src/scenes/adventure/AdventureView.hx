package scenes.adventure;

import common.struct.Size;
import common.struct.Coordinate;
import engine.Frame;
import engine.MainLoop;
import engine.Projection;
import engine.Scene;
import haxe.ui.containers.Box;

@:build(haxe.ui.macros.ComponentMacros.build("./components/adventure.xml"))
class AdventureView extends Box {
	private var scene: Scene;

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		this.scene.loop.render(HUD, this);
	}

	public function update(frame: Frame) {
		var viewportW = scene.camera.width * (scene.camera.offsetX * 2);
		var viewportH = scene.camera.height * (scene.camera.offsetY * 2);

		var w = scene.camera.width - viewportW;
		var h = scene.camera.height - viewportH;

		sideWrapper.width = w;
		sideWrapper.height = scene.camera.height - h;
		bottomWrapper.height = h;
	}
}
