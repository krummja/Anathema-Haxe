package domain.systems;

import domain.components.Moniker;
import engine.Frame;
import domain.components.Sprite;
import ecs.Query;
import ecs.System;

class DebugSystem extends System {
	var query: Query;

	public function new() {
		query = new Query({
			all: [Sprite],
		});
	}

	public override function update(frame: Frame) {
		var entities = [];

		for (entity in query) {
			if (entity.has(Moniker) && entity.get(Moniker).displayName == "Tall grass") {
				entities.push(entity);
			}
		}
	}
}
