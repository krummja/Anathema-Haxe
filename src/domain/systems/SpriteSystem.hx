package domain.systems;

import ecs.Entity;
import ecs.Query;
import engine.Frame;
import engine.Projection;
import engine.SpriteView;
import engine.TileResources;
import domain.components.*;

class SpriteSystem extends DomainSystem {
	var sprites: Query;
	var views: Map<String, SpriteView>;

	public function new() {
		views = new Map();

		sprites = new Query({
			all: [Sprite],
			none: [IsDestroyed],
		});

		sprites.onEntityAdded((entity) -> attachView(entity));
		sprites.onEntityRemoved((entity) -> detachView(entity));

		loop.app.s2d.renderer.globals.set("daylight", world.clock.getDaylight());
	}

	public override function update(frame: Frame) {
		if (world.clock.tickDelta > 0) {
			var daylight = world.clock.getDaylight();
			loop.app.s2d.renderer.globals.set("daylight", daylight);
		}

		for (entity in sprites) {
			var view = views.get(entity.id);
			if (view != null) {
				syncView(entity.get(Sprite), view, entity);
			}
		}
	}

	private function attachView(entity: Entity) {
		var sprite = entity.get(Sprite);
		if (sprite == null) {
			return;
		}

		var view = new SpriteView();
		view.attachTile(TileResources.get(sprite.tileKey));
		views.set(entity.id, view);

		syncView(sprite, view, entity);

		loop.render(sprite.layer, view.drawable);
	}

	private function detachView(entity: Entity) {
		var view = views.get(entity.id);
		if (view == null) {
			return;
		}

		view.drawable.remove();
		views.remove(entity.id);
	}

	private function syncView(sprite: Sprite, view: SpriteView, entity: Entity) {
		view.setTile(TileResources.get(sprite.tileKey));

		view.sync(
			sprite.primary,
			sprite.secondary,
			sprite.outline,
			sprite.background,
			sprite.isShrouded,
			sprite.isLit,
			sprite.lightColor,
			sprite.lightIntensity,
			sprite.visible
		);

		var worldPos = sprite.renderPos != null ? sprite.renderPos : entity.pos;
		var coord = Projection.worldToPixel(worldPos.x, worldPos.y);

		var offsetX = sprite.renderOffset != null ? sprite.renderOffset.x : 0;
		var offsetY = sprite.renderOffset != null ? sprite.renderOffset.y : 0;

		view.setPosition(coord.x + offsetX, coord.y + offsetY);
	}
}
