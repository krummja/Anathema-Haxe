package scenes.adventure;

import engine.Frame;
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
		// The viewport is the area of the screen reserved for the view into the game.
		var w = scene.camera.width - scene.camera.viewportWidth;
		var h = scene.camera.height - scene.camera.viewportHeight;
		sideContainer.width = w;
		sideContainer.height = scene.camera.height - h + 1;
		bottomContainer.height = h;

		zoom.text = ' zoom: ${scene.camera.zoom}';
		camx.text = 'cam x: ${scene.camera.x}';
		posx.text = 'pos x: ${scene.world.player.x}';
	}
}
