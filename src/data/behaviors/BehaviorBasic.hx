package data.behaviors;

import components.Position;
import components.IsPlayer;
import echoes.Echoes;
import components.Actor;
import echoes.Entity;
import engine.Behavior;

class BehaviorBasic extends Behavior {
	public function new() {}

	public override function takeAction(entity: Entity) {
		var actor = entity.get(Actor);
		var targets = Echoes.activeEntities.filter((e) -> e.exists(IsPlayer));
		var target = targets.first();

		if (tryMoveToward(entity, target.get(Position).asCoordinate())) {
			return;
		}

		wait(entity);
	}
}
