package domain.systems;

import domain.events.ConsumeEnergyEvent;
import data.EnergyActionType;
import engine.Frame;
import domain.components.*;
import ecs.Entity;
import ecs.Query;
import ecs.System;

class EnergySystem extends System {
	public static function consumeEnergy(entity: Entity, type: EnergyActionType): Int {
		var cost = getEnergyCost(entity, type);
		entity.fireEvent(new ConsumeEnergyEvent(cost));
		return cost;
	}

	public static function getEnergyCost(entity: Entity, type: EnergyActionType): Int {
		switch type {
			case ACT_WAIT:
				return 500;
			case ACT_MOVE:
				return 25;
			case _:
				return 25;
		}
	}

	public var isPlayersTurn(default, null): Bool;

	var query: Query;

	public function new() {
		isPlayersTurn = false;
		query = new Query({
			all: [Energy],
			none: [IsDetached, IsDestroyed],
		});
	}

	private function getNext(): Entity {
		var entity = query.max((e) -> e.get(Energy).value);
		if (entity == null) {
			return null;
		}

		var energy = entity.get(Energy);

		if (!energy.hasEnergy) {
			var tickAmount = -energy.value;
			world.clock.incrementTick(tickAmount);
			query.each((e) -> e.get(Energy).addEnergy(tickAmount));
		}

		return entity;
	}

	public override function update(frame: Frame) {
		world.clock.clearDeltas();

		if (isPlayersTurn && world.player.entity.get(Energy).hasEnergy) {
			// TODO
			return;
		}

		while (true) {
			var entity = getNext();
			if (entity.has(IsPlayer)) {
				isPlayersTurn = true;
				break;
			} else {
				isPlayersTurn = false;
				world.behavior.takeAction(entity);
			}
		}
	}
}
