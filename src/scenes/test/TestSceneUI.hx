package scenes.test;

import haxe.ui.events.MouseEvent;
import engine.Scene;
import engine.Frame;
import engine.UIComponent;

@:xml('
<vbox>
    <style>
        .box .label {
            color: #ff0000;
        }
    </style>

	<vbox>
		<label style="default" id="testVal" />
		<button id="testButton" text="Click!" />
	</vbox>
</vbox>
')
class TestSceneUI extends UIComponent {
	@:bind(testVal.text)
	private var _test: String;

	@:bind(testButton, MouseEvent.CLICK)
	private function onButtonClick(_) {
		trace("Click!");
	}

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		testVal.text = "Test";
		scene.loop.layers.render(HUD, this);
	}

	public function update(frame: Frame) {}
}
