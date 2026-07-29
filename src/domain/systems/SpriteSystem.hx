package domain.systems;

import engine.Projection;
import engine.Frame;
import ecs.Query;
import ecs.System;
import domain.components.*;

class SpriteSystem extends System {
	var sprites: Query;

	public function new() {
		sprites = new Query({
			all: [Sprite],
			none: [IsDestroyed],
		});

		sprites.onEntityAdded((entity) -> renderSprite(entity.get(Sprite)));
		sprites.onEntityRemoved((entity) -> removeSprite(entity.get(Sprite)));

		loop.app.s2d.renderer.globals.set("daylight", world.clock.getDaylight());
	}

	public override function update(frame: Frame) {
		if (world.clock.tickDelta > 0) {
			var daylight = world.clock.getDaylight();
			loop.app.s2d.renderer.globals.set("daylight", daylight);
		}

		for (entity in sprites) {
			var sprite = entity.get(Sprite);
			var worldPos = sprite.renderPos != null ? sprite.renderPos : entity.pos;
			var coord = Projection.worldToPixel(worldPos.x, worldPos.y);
			sprite.setPosition(coord.x, coord.y);
		}
	}

	private function renderSprite(drawable: Drawable) {
		if (drawable != null) {
			loop.render(drawable.layer, drawable.drawable);
		}
	}

	private function removeSprite(drawable: Drawable) {
		if (drawable != null) {
			drawable.drawable.remove();
		}
	}
}
