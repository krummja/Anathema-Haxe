package engine;

import h2d.Font;

class TextResources {
	public static var BIZCAT: Font;
	public static var BIZCAT_PATH: String;

	public static function init() {
		BIZCAT = hxd.Res.fnt.bizcat.toFont();
		BIZCAT_PATH = hxd.Res.fnt.bizcat.name;
		trace("TextResources initialized");
	}
}
