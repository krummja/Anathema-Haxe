package domain.systems;

import domain.components.Health;
import domain.components.IsDead;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
import domain.prefabs.Spawner;
import ecs.Entity;
import ecs.Query;
import ecs.System;
import engine.Frame;

class DeathSystem extends System {
	private var query: Query;

	public function new() {
		this.query = new Query({
			all: [IsDead],
			none: [IsInventoried, IsDestroyed],
		});
	}

	public override function update(frame: Frame) {
		this.query.each((e: Entity) -> {
			var health = e.get(Health);

			if (health.corpsePrefab != null) {
				var corpse = Spawner.spawn(health.corpsePrefab, e.pos);
			}

			e.add(new IsDestroyed());
		});
	}
}
