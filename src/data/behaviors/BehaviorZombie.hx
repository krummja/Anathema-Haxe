package data.behaviors;

import common.algorithm.Distance;
import domain.components.Actor;
import ecs.Entity;
import engine.Behavior;

class BehaviorZombie extends Behavior {
	public override function takeAction(entity: Entity) {
		var actor = entity.get(Actor);
		var target = getTarget(entity);

		if (target != null) {
			if (actor.lastKnownTargetPosition == null) {
				// TODO
			}

			actor.lastKnownTargetPosition = target.pos;
		}

		var actorPos = entity.pos.toIntPoint();
		var leashPos = actor.leashPosition.toIntPoint();

		if (!actor.isReturningToLeash && actor.lastKnownTargetPosition != null) {
			var goalPos = actor.lastKnownTargetPosition.toIntPoint();

			var distanceFromLeash = Distance.Diagonal(leashPos, actorPos);
			var distanceToTarget = Distance.Diagonal(leashPos, goalPos);

			if (distanceToTarget < actor.leashDistance && distanceFromLeash < actor.leashDistance) {
				if (target != null) {
					if (tryAttackingNearby(entity)) {
						return;
					}
				}

				if (tryMoveToward(entity, actor.lastKnownTargetPosition)) {
					return;
				}

				trace("Failed to move toward target");
				wait(entity);
			}

			trace("Returning to leash home");
			actor.isReturningToLeash = true;
			actor.lastKnownTargetPosition = null;
		}

		if (actor.leashPosition == null) {
			trace("Warning: Actor is missing leash position!");
			wait(entity);
			return;
		}

		if (tryMoveToward(entity, actor.leashPosition)) {
			return;
		}

		if (actorPos.equals(leashPos)) {
			actor.isReturningToLeash = false;
		}

		wait(entity);
	}
}
