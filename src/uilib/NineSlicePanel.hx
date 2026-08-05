package uilib;

import haxe.ui.containers.Box;

class NineSlicePanel extends Box {
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
