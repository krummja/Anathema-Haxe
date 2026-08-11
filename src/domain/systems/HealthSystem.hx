package domain.systems;

import domain.components.Health;
import domain.components.IsDestroyed;
import ecs.Entity;
import ecs.Query;
import engine.Frame;

class HealthSystem extends DomainSystem {
	private var query: Query;

	public function new() {
		this.query = new Query({
			all: [Health],
			none: [IsDestroyed],
		});
	}

	public override function update(frame: Frame) {
		var tickDelta = world.clock.tickDelta;

		if (tickDelta <= 0) {
			return;
		}

		query.each((e: Entity) -> {
			var health = e.get(Health);
			health.onTickDelta(tickDelta);
		});
	}
}
