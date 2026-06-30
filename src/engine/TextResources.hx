package engine;

import h2d.Font;

class TextResources {
	public static var BIZCAT: Font;

	public static function init() {
		BIZCAT = hxd.Res.fnt.bizcat.toFont();
		trace("TextResources initialized");
	}
}
