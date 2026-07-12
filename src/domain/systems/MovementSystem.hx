package domain.systems;

import engine.Frame;
import ecs.Entity;
import domain.components.Moved;
import domain.components.IsDestroyed;
import domain.components.MoveComplete;
import domain.components.Move;
import ecs.System;
import ecs.Query;

class MovementSystem extends System {
	var movers: Query;
	var moved: Query;
	var completed: Query;

	public function new() {
		movers = new Query({
			all: [Move],
			none: [MoveComplete, IsDestroyed],
		});

		movers.onEntityAdded((e) -> {
			var move = e.get(Move);
			move.start = e.pos;
			move.startTime = loop.frame.elapsed;
		});

		completed = new Query({
			all: [MoveComplete],
			none: [IsDestroyed],
		});

		moved = new Query({
			all: [Moved],
			none: [IsDestroyed],
		});
	}

	public function finishMoveFast(entity: Entity): Bool {
		var move = entity.get(Move);

		if (move == null) {
			return false;
		}

		move.duration = 0.015;
		return true;
	}

	public override function update(frame: Frame) {
		for (entity in completed) {
			entity.remove(MoveComplete);
		}

		for (entity in moved) {
			entity.remove(Moved);
		}

		for (entity in movers) {
			var move = entity.get(Move);

			if (!move.isMoveFired) {
				entity.add(new Moved());
				move.isMoveFired = true;
			}

			if (entity.pos == null) {
				entity.pos = move.start;
				if (move.start == null) {
					trace('Move start is null...', move.start);
				}
			}

			var current = entity.pos.toWorld();
			var distanceSq = current.distance(move.goal, WORLD, EUCLIDEAN);

			var currentDuration = frame.elapsed - move.startTime;
			var progress = (currentDuration / move.duration).clamp(0, 1);
			var newPos = move.start.ease(move.goal, progress, move.ease);
			entity.pos = newPos;

			if (distanceSq < move.epsilon * move.epsilon) {
				entity.remove(move);
				entity.add(new MoveComplete());
			}
		}
	}
}
