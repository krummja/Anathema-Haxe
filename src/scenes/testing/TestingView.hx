package scenes.testing;

import engine.Frame;
import engine.Scene;
import haxe.ui.components.Image;
import haxe.ui.containers.Box;
import haxe.ui.containers.Grid;

@:xml('
	<box></box>
')
class TestPanel extends Box {
	public function new(borderWidth: Int = 1) {
		super();

		customStyle = {
			width: 512,
			height: 256,
			backgroundImage: "images/9-slice-4.png",
			backgroundImageSliceTop: 17.0,
			backgroundImageSliceLeft: 17.0,
			backgroundImageSliceRight: 143.0,
			backgroundImageSliceBottom: 143.0,
		};
	}
}

@:build(haxe.ui.macros.ComponentMacros.build("./components/testing.xml"))
class TestingView extends Box {
	private var scene: Scene;

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		this.scene.loop.render(HUD, this);

		var panel = new TestPanel(3);
		panel.width = 300;
		panel.height = 300;
		addComponent(panel);
	}

	public function update(frame: Frame) {
		var w = scene.loop.window.width;
		var h = scene.loop.window.height;
		// screenSize.text = '${w} x ${h}';

		fps.text = '${frame.smoothFps.floor()}';
	}
}
