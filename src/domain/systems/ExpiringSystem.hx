package domain.systems;

import engine.Frame;
import domain.components.IsDestroyed;
import domain.components.Expiring;
import ecs.Query;

class ExpiringSystem extends DomainSystem {
	var query: Query;

	public function new() {
		query = new Query({
			all: [Expiring],
			none: [IsDestroyed],
		});
	}

	public override function update(frame: Frame) {
		for (e in query) {
			var component = e.get(Expiring);
			var life = (component.lifetime / component.duration);

			component.lifetime += frame.tmod;

			if (life > 1) {
				e.add(new IsDestroyed());
			}
		}
	}
}
