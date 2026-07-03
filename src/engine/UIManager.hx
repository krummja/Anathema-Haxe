package engine;

import haxe.ui.*;
import haxe.ui.containers.*;

@:xml('
<vbox width="100%" height="100%" style="padding: 10px">
    <hbox id="wrapper" width="100%" height="100%">
        <vbox width="100%" />
    </hbox>
</vbox>
')
class UIRoot extends Box {
	public function new(width: Float, height: Float) {
		super();
		wrapper.width = width;
		wrapper.height = height;
	}

	public function update() {}
}

class UIManager {
	public static var overlay_root: UIRoot;
	public static var ui_root: UIRoot;

	public var loop(get, null): MainLoop;

	public function new() {
		Toolkit.init({root: this.loop.layers.root});
		ui_root = new UIRoot(this.loop.window.width, this.loop.window.height);
		this.loop.layers.render(HUD, ui_root);
	}

	private function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}
}
