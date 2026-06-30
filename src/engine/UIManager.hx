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
}

class UIManager {}
