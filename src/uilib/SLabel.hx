package uilib;

import haxe.ui.components.Label;

class SLabel extends Label {
	public function new(?value: Null<String>, ?color: Int = 0xffffff) {
		super();
		this.getTextDisplay().sprite.smooth = true;
		this.customStyle = {
			fontName: "fnt/fira_code_semibold.fnt",
			fontSize: 16,
			color: color,
		};

		if (value != null) {
			text = value;
		}
	}
}
