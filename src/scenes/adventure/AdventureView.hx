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

		// sideWrapper.visible = false;
		// bottomWrapper.visible = false;
	}

	public function update(frame: Frame) {
		var w = scene.camera.width - scene.camera.viewportWidth;
		var h = scene.camera.height - scene.camera.viewportHeight;

		sideWrapper.width = w;
		sideWrapper.height = scene.camera.height - h;
		bottomWrapper.height = h;

		zoom.text = ' zoom: ${scene.camera.zoom}';
		camx.text = 'cam x: ${scene.camera.x}';
		posx.text = 'pos x: ${scene.world.player.x}';
	}
}
