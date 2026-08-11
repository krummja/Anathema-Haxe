package domain.systems;

import engine.Frame;
import domain.components.IsDestroyed;
import ecs.Query;

class DestroySystem extends DomainSystem {
	var query: Query;

	public function new() {
		query = new Query({
			all: [IsDestroyed],
		});
	}

	public override function update(frame: Frame) {
		for (entity in query) {
			var destroying = entity.get(IsDestroyed);
			if (destroying.pass > 0) {
				entity.destroy();
			} else {
				destroying.pass++;
			}
		}
	}
}
