package uilib;

import haxe.ui.components.Label;

class XLLabel extends Label {
	public function new() {
		super();
		this.getTextDisplay().sprite.smooth = true;
		this.customStyle = {
			fontName: "fnt/fira_code_semibold.fnt",
			fontSize: 22,
		};
	}
}
