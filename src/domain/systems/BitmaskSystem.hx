package domain.systems;

import data.Bitmasks;
import ecs.Entity;
import ecs.Query;
import ecs.System;
import domain.components.*;

class BitmaskSystem extends System {
	var query: Query;

	public function new() {
		query = new Query({
			all: [Sprite, BitmaskSprite, Explored],
			none: [IsDestroyed],
		});

		query.onEntityAdded((e) -> {
			refreshMaskAndNeighbors(e);
		});
	}

	public function compute(entity: Entity): Int {
		var bitmaskSprite = entity.get(BitmaskSprite);
		var invert = bitmaskSprite.bitmask.invertUnexplored;

		return Bitmasks.sumMask((x, y) -> {
			var pos = entity.pos.toIntPoint().add(x, y).asWorld();
			var list = world.getEntitiesAt(pos);

			for (e in list) {
				if (!invert && !e.has(Explored)) {
					continue;
				}

				if (!e.has(BitmaskSprite) || e.has(IsDestroyed)) {
					continue;
				}

				if (bitmaskSprite.bitmaskTypes.contains(e.get(BitmaskSprite).bitmaskType)) {
					return true;
				}
			}

			return false;
		});
	}

	private function refreshMaskAndNeighbors(entity: Entity) {
		refreshMask(entity);

		var bitmaskTypes = entity.get(BitmaskSprite).bitmaskTypes;
		var pos = entity.pos.toWorld().toIntPoint();
		var neighbors = world.getNeighborEntities(pos);

		for (list in neighbors) {
			for (e in list) {
				if (!e.has(BitmaskSprite) || !e.has(Explored) || e.has(IsDestroyed)) {
					continue;
				}

				if (bitmaskTypes.intersects(e.get(BitmaskSprite).bitmaskTypes)) {
					refreshMask(e);
				}
			}
		}
	}

	private function refreshMask(entity: Entity) {
		var bitmaskSprite = entity.get(BitmaskSprite);

		if (!bitmaskSprite.overwriteTile) {
			return;
		}

		var mask = compute(entity);
		var tileKey = Bitmasks.getTileKey(bitmaskSprite.bitmaskType, mask);
		var sprite = entity.get(Sprite);

		sprite.tileKey = tileKey;
	}
}
