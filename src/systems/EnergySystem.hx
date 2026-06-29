package systems;

import echoes.View;
import echoes.Entity;
import data.EnergyActionType;
import components.IsPlayer;
import components.IsDestroyed;
import components.Energy;
import systems.System;
import events.ConsumeEnergyEvent;

class EnergySystem extends System {
	public static function getEnergyCost(entity: Entity, type: EnergyActionType): Int {
		switch (type) {
			case ACT_MOVE:
				return 50;
			case ACT_WAIT:
				return 500;
			case _:
				return 50;
		}
	}

	public var isPlayerTurn(default, null): Bool;

	private var _query: View<Energy> = getLinkedView(Energy);

	private function getNext(): Entity {
		var entity = query.max((e) -> e.get(Energy).value);
		var energy = entity.get(Energy);

		if (!energy.hasEnergy) {
			var tickAmount = -energy.value;
			world.clock.incrementTick(tickAmount);
			query.each((e) -> e.get(Energy).addEnergy(tickAmount));
		}

		return entity;
	}

	@:update private function update(time: Float): Void {
		var frame = loop.frame;
		world.clock.clearDeltas();

		while (true) {
			var entity = getNext();

			if (entity.exists(IsPlayer)) {
				isPlayerTurn = true;
				break;
			} else {
				isPlayerTurn = false;
			}
		}
	}

	@:update private function processEnergy(entity: Entity, event: ConsumeEnergyEvent, energy: Energy) {
		energy.consumeEnergy(event.value);
		entity.remove(event);
	}

	private override function get_query(): Query {
		return _query.entities.filter((e) -> {
			return !e.exists(IsDestroyed);
		});
	}
}
