package domain.systems;

import common.struct.FloatPoint;
import engine.Frame;
import domain.components.*;
import ecs.Query;
import ecs.System;

class AttackSystem extends System {
	private var query: Query;

	public function new() {
		query = new Query({
			all: [Attacker, Sprite],
			none: [IsDestroyed],
		});

		query.onEntityAdded((e) -> {
			var attacker = e.get(Attacker);
			attacker.startTime = loop.frame.elapsed;
			attacker.startPos = e.pos;
		});
	}

	public override function update(frame: Frame): Void {
		for (entity in query) {
			// Don't attack moving entities
			if (entity.has(Move)) {
				continue;
			}

			var attacker = entity.get(Attacker);
			var curDuration = frame.elapsed - attacker.startTime;
			var progress = (curDuration / attacker.duration).clamp(0, 1);
			var offset = attacker.direction.toOffset();
			var target = new FloatPoint(offset.x * 0.3, offset.y * 0.3);
			var goal = entity.pos.add(target.asWorld());
			var newPos = entity.pos.easeZig(goal, progress, attacker.ease);

			entity.offset = newPos;

			if (progress >= 1) {
				entity.offset = attacker.startPos;
				entity.remove(Attacker);
			}
		}
	}
}
