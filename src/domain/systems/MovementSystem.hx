package domain.systems;

import engine.Frame;
import ecs.Entity;
import domain.components.Moved;
import domain.components.IsDestroyed;
import domain.components.MoveComplete;
import domain.components.Move;
import domain.components.Sprite;
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
			var sprite = e.get(Sprite);

			// If several turns resolve for this entity in the same rendered
			// frame (e.g. a fast creature, or a burst of AI turns after the
			// player waits), this Move may be replacing one that never got a
			// chance to animate. Continue the visual tween from wherever the
			// sprite is currently drawn instead of the logical start, so the
			// entity glides quickly across the skipped ground rather than
			// teleporting.
			move.start = (sprite != null && sprite.renderPos != null) ? sprite.renderPos : e.pos;
			move.startTime = loop.frame.elapsed;

			// Snap the logical position to the destination immediately so
			// AI targeting, vision, and occupancy checks always see where
			// the entity is headed rather than a stale in-between position.
			// The sprite eases from move.start to move.goal separately via
			// Sprite.renderPos, so this doesn't affect what's rendered.
			e.pos = move.goal;

			if (sprite != null) {
				sprite.renderPos = move.start;
			}
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

			var currentDuration = frame.elapsed - move.startTime;
			var progress = (currentDuration / move.duration).clamp(0, 1);
			var newPos = move.start.ease(move.goal, progress, move.ease);

			var sprite = entity.get(Sprite);
			if (sprite != null) {
				sprite.renderPos = newPos;
			}

			var distanceSq = newPos.toWorld().distance(move.goal, WORLD, EUCLIDEAN);

			if (distanceSq < move.epsilon * move.epsilon) {
				if (sprite != null) {
					sprite.renderPos = null;
				}

				entity.remove(move);
				entity.add(new MoveComplete());
			}
		}
	}
}
