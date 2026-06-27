package systems;

import echoes.Entity;
import components.Energy;

class EnergySystem extends System {
	public var isPlayerTurn(default, null): Bool;

	// private function getNext(): Entity {}

	@:update private function updateEnergy(entity: Entity, energy: Energy) {
		if (energy.hasEnergy) {
			var tickAmount = -energy.value;
		}
	}
}
