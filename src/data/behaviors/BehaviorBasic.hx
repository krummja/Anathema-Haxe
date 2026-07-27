package data.behaviors;

import common.tools.Performance;
import domain.components.*;
import ecs.Entity;
import engine.Behavior;

class BehaviorBasic extends Behavior {
	public override function takeAction(entity: Entity) {
		var actor = entity.get(Actor);
		var target = getTarget(entity);

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
