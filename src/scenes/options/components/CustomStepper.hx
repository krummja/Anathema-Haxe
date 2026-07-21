package scenes.options.components;

import haxe.ui.components.Label;
import haxe.ui.components.OptionStepper;

class CustomStepper extends OptionStepper {
	public function new() {
		super();
		var _value = findComponent("value", Label);
		trace(this.height);
		_value.customStyle = {
			height: this.height,
			verticalAlign: "center",
		};
	}
}
