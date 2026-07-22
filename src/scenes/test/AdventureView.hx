package scenes.test;

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

		panelWrapper.backgroundColor = 0x212121;
		panelWrapper.borderColor = 0x404040;
		panelWrapper.borderSize = 1.0;

		var colWidth = MainLoop.getInstance().UNIT_X;
		var colPercent = colWidth / scene.camera.windowColumns;
		panelWrapper.percentWidth = scene.camera.offsetX * 100.0;
	}
}
