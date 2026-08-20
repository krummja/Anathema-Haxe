package uilib;

import haxe.ui.containers.Box;

class NineSlicePanel extends Box {
	public function new(image: String, w: Int, h: Int, border: Int = 1) {
		super();

		var imageRes = hxd.Res.loader.load(image).toImage();
		var imageInfo = imageRes.getInfo();
		var width = imageInfo.width;
		var height = imageInfo.height;

		var right = width - border;
		var bottom = height - border + 1;

		customStyle = {
			width: w,
			height: h,
			backgroundImage: image,
			backgroundImageSliceTop: border,
			backgroundImageSliceLeft: border,
			backgroundImageSliceRight: right,
			backgroundImageSliceBottom: bottom,
		};
	}
}
