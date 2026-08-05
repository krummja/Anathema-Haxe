package scenes.testing;

import engine.Frame;
import engine.Scene;
import haxe.ui.containers.Box;
import haxe.ui.containers.VBox;
import uilib.LogPanel;
import uilib.SLabel;

@:build(haxe.ui.macros.ComponentMacros.build("./components/testing.xml"))
class TestingView extends Box {
	private var scene: Scene;

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		this.scene.loop.render(HUD, this);
	}

	public function update(frame: Frame) {
		fps.text = '${frame.smoothFps.floor()}';
	}
}
