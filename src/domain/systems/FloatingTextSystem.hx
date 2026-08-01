package domain.systems;

import common.struct.Coordinate;
import domain.components.FloatingText;
import ecs.Query;
import ecs.System;
import engine.Frame;
import engine.TextResources;
import h2d.Object;
import h2d.Text;

typedef FloatingTextOb = {
	var ob: Object;
	var text: Text;
	var start: Coordinate;
}

class FloatingTextSystem extends System {
	private var query: Query;
	private var floaters: Map<String, FloatingTextOb>;

	public function new() {
		floaters = new Map();

		query = new Query({
			all: [FloatingText],
		});

		query.onEntityAdded((e) -> {
			var floater = e.get(FloatingText);
			var ob = new Object();

			var text = new Text(TextResources.BIZCAT, ob);
			text.color = floater.color.toHxdColor();
			text.text = floater.text;
			text.textAlign = Center;
			text.scale(1);
			text.dropShadow = {
				dx: 1,
				dy: 1,
				color: 0x1c1c1c,
				alpha: 1,
			};

			var offsetPos = new Coordinate(0.5, -0.5, WORLD).toPixel();
			text.x = offsetPos.x;
			text.y = offsetPos.y;

			loop.render(OVERLAY, ob);

			var targetPos = e.pos.toPixel();
			ob.x = targetPos.x;
			ob.y = targetPos.y;
			floaters.set(e.id, {
				ob: ob,
				text: text,
				start: targetPos,
			});
		});

		query.onEntityRemoved((e) -> {
			var bm = floaters.get(e.id);
			bm.ob.remove();
			floaters.remove(e.id);
		});
	}

	public override function update(frame: Frame) {
		for (e in query) {
			var component = e.get(FloatingText);
			var floater = floaters.get(e.id);
			var life = (component.lifetime / component.duration);

			var target = floater.start.y - 50;
			floater.ob.y = floater.start.y.lerp(target, (life).ease(EASE_LINEAR));
			floater.ob.alpha = 1;

			var scale = 0.75;
			floater.text.setScale(scale);

			component.lifetime += frame.tmod;

			if (life > 1) {
				e.destroy();
			}
		}
	}
}
