package domain.systems;

import domain.events.ConsumeEnergyEvent;
import domain.components.IsPlayer;
import common.struct.Coordinate;
import domain.components.Move;
import domain.components.MoveComplete;
import engine.Frame;
import domain.components.Path;
import ecs.Query;
import ecs.System;

class PathFollowSystem extends System {
	private var query: Query;

	public function new() {
		query = new Query({
			all: [Path],
		});
	}

	public override function update(frame: Frame) {
		for (entity in query) {
			var path = entity.get(Path);

			if (entity.has(MoveComplete) || !entity.has(Move)) {
				if (path.hasNext()) {
					var next = path.next();
					var target = new Coordinate(next.x, next.y, WORLD);
					var speed = 0.05;

					if (entity.has(IsPlayer)) {
						var cost = EnergySystem.getEnergyCost(entity, ACT_MOVE);
						entity.fireEvent(new ConsumeEnergyEvent(cost));
					}

					entity.add(new Move(target, speed, EASE_LINEAR));
				} else {
					entity.remove(path);
				}
			}
		}
	}
}
