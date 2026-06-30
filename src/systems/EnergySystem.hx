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
				return 100;
			case _:
				return 50;
		}
	}

	public static function consumeEnergy(entity: Entity, type: EnergyActionType): Int {
		var cost = getEnergyCost(entity, type);
		entity.fireEvent(new ConsumeEnergyEvent(cost));
		return cost;
	}

	public var isPlayerTurn(default, null): Bool;

	public var energized(get, never): Iterable<Entity>;

	private var _energized: View<Energy> = getLinkedView(Energy);

	private function getNext(): Entity {
		var entity = energized.max((e) -> e.get(Energy).value);
		var energy = entity.get(Energy);

		if (!energy.hasEnergy) {
			var tickAmount = -energy.value;
			world.clock.incrementTick(tickAmount);
			energized.each((e) -> e.get(Energy).addEnergy(tickAmount));
		}

		return entity;
	}

	@:update
	private function update(time: Float): Void {
		var frame = loop.frame;
		world.clock.clearDeltas();

		if (isPlayerTurn && world.player.entity.get(Energy).hasEnergy) {
			return;
		}

		while (true) {
			var entity = getNext();

			if (entity.exists(IsPlayer)) {
				isPlayerTurn = true;
				break;
			} else {
				isPlayerTurn = false;
				world.behavior.takeAction(entity);
			}
		}
	}

	private function get_energized(): Iterable<Entity> {
		return _energized.entities.filter((e) -> {
			return !e.exists(IsDestroyed);
		});
	}
}
