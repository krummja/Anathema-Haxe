package data.behaviors;

import common.tools.Performance;
import domain.components.*;
import ecs.Entity;
import engine.Behavior;

class BehaviorBasic extends Behavior {
	public function new() {}

	public override function takeAction(entity: Entity) {
		var actor = entity.get(Actor);

		Performance.start("get-target");
		var target = getTarget(entity);
		Performance.stop("get-target");

		if (target == null) {
			if (actor.lastKnownTargetPosition != null) {
				if (tryMoveToward(entity, actor.lastKnownTargetPosition)) {
					return;
				}
			}

			wait(entity);

			return;
		}

		actor.lastKnownTargetPosition = target.pos;

		if (tryMoveToward(entity, target.pos)) {
			return;
		}

		wait(entity);
	}
}
