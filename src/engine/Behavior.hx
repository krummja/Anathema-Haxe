package engine;

import events.ConsumeEnergyEvent;
import systems.EnergySystem;
import echoes.Entity;

class Behavior {
	public function takeAction(entity: Entity): Void {
		wait(entity);
	}

	public function wait(entity: Entity): Void {
		var cost = EnergySystem.getEnergyCost(entity, ACT_WAIT);
		entity.add(new ConsumeEnergyEvent(cost));
	}
}
