package scenes.ui.label;

import engine.Frame;
import h3d.Vector4;
import common.struct.FloatPoint;
import engine.RenderLayerManager.RenderLayerType;
import engine.TextResources;
import h2d.Text;
import h2d.Object;
import engine.Scene;

typedef LabelSettings = {
	var content: String;
	var ?fontScale: Float;
	var ?fontColor: Vector4;
	var ?layer: RenderLayerType;
	var ?pos: FloatPoint;
	var ?textAlign: Align;
}

class Label extends Scene {
	public var content(get, set): String;
	public var pos(get, set): FloatPoint;
	public var color(get, set): Vector4;
	public var scale(get, set): Float;

	private var settings: LabelSettings;
	private var ob: Object;
	private var contentOb: Text;

	public function new(settings: LabelSettings) {
		this.settings = settings;

		ob = new Object();
		contentOb = new Text(TextResources.BIZCAT);

		this.content = content;

		contentOb.setScale(settings.fontScale.or(1));
		contentOb.textAlign = settings.textAlign.or(Center);
		contentOb.color = settings.fontColor.or(0xffffff.toHxdColor());
		contentOb.x = settings.pos != null ? settings.pos.x : 0;
		contentOb.y = settings.pos != null ? settings.pos.y : 0;
		ob.addChild(contentOb);

		loop.render(settings.layer.or(HUD), ob);
	}

	@:allow(engine.Scene)
	private function remove() {
		ob.remove();
	}

	private function get_content(): String {
		return settings.content;
	}

	private function set_content(value: String): String {
		contentOb.text = value;
		return settings.content = value;
	}

	private function get_pos(): FloatPoint {
		return settings.pos;
	}

	private function set_pos(value: FloatPoint): FloatPoint {
		contentOb.x = value.x;
		contentOb.y = value.y;
		return settings.pos = value;
	}

	private function get_color(): Vector4 {
		return settings.fontColor;
	}

	private function set_color(value: Vector4): Vector4 {
		contentOb.color = value;
		return settings.fontColor = value;
	}

	private function get_scale(): Float {
		return settings.fontScale;
	}

	private function set_scale(value: Float): Float {
		contentOb.setScale(value);
		return settings.fontScale = value;
	}
}
