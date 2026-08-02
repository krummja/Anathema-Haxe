package scenes.testing.components.panel;

import haxe.ui.components.Image;
import haxe.ui.containers.Box;
import hxd.Res;
import shaders.NineSliceShader;

class UIPanel extends Image {
	public function new() {
		super();

		var background = Res.images.panel.toTexture();
		var width = background.width;
		var height = background.height;

		var shader = new NineSliceShader(background, width, height, 1.0, 1.0, 0, 0, 0, 0);
		this.getImageDisplay().addShader(shader);
	}
}
