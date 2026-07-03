package scenes.test;

import engine.Frame;
import engine.UIComponent;

@:xml('
<vbox>
    <style>
        .box .label {
            color: #ff0000;
        }
    </style>
    <label style="default" id="testVal" />
</vbox>
')
class TestSceneUI extends UIComponent {
	@:bind(testVal.text)
	private var _test: String;

	public function new(test: String) {
		super();
		this._test = test;
	}

	public function update(frame: Frame) {}
}
