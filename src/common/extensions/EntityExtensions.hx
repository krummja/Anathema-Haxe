package common.extensions;

import echoes.Entity;
import engine.MainLoop;
import engine.EntityEvent;
import events.MovedEvent;
import components.Position;
import common.struct.Coordinate;

class EntityExtensions {
	public static function fireEvent(entity: Entity, event: EntityEvent) {
		for (component in entity.getComponents()) {
			var instance = component.get(entity);
			var fn = Reflect.field(instance, "onEvent");
			Reflect.callMethod(instance, fn, [event]);
		}
	}

	public static function getPosition(entity: Entity): Coordinate {
		return entity.get(Position).asCoordinate();
	}

	public static function setPosition(entity: Entity, value: Coordinate): Coordinate {
		var position = entity.get(Position);
		var prevChunkIdx = position.asCoordinate().toChunkId();

		var p = value.toPixel();
		var w = value.toWorld();

		entity.get(Position).set(w.x, w.y);
		var nextChunkIdx = position.asCoordinate().toChunkId();

		if (prevChunkIdx != nextChunkIdx) {
			var prevChunk = MainLoop.getInstance().world.chunks.getChunkById(prevChunkIdx);
			if (prevChunk != null) {
				prevChunk.removeEntity(entity);
			}
		}

		var nextChunk = MainLoop.getInstance().world.chunks.getChunkById(nextChunkIdx);
		if (nextChunk != null) {
			nextChunk.setEntityPosition(entity);
		}

		entity.fireEvent(new MovedEvent(entity, w));
		return w;
	}
}
