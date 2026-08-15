package domain.systems;

import common.struct.FloatPoint;
import engine.Frame;
import domain.components.*;
import ecs.Query;

class AttackSystem extends DomainSystem {
	private var query: Query;

	public function new() {
		query = new Query({
			all: [Attacker, Sprite],
			none: [IsDestroyed],
		});

		query.onEntityAdded((e) -> {
			var attacker = e.get(Attacker);
			attacker.startTime = loop.frame.elapsed;
		});
	}

	public override function update(frame: Frame): Void {
		for (entity in query) {
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
			var sprite = entity.get(Sprite);

			// A cosmetic lunge nudge, not real movement - renderOffset instead of
			// renderPos so it doesn't drag the camera along (see Drawable.renderOffset).
			sprite.renderOffset = newPos.sub(entity.pos).toPixel().toFloatPoint();

			if (progress >= 1) {
				sprite.renderOffset = null;
				entity.remove(Attacker);
			}
		}
	}
}
