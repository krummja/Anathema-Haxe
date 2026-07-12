package domain.systems;

import common.tools.Performance;
import domain.events.ConsumeEnergyEvent;
import data.EnergyActionType;
import engine.Frame;
import ecs.Entity;
import ecs.Query;
import ecs.System;
import domain.components.*;

class EnergySystem extends System {
	public static function consumeEnergy(entity: Entity, type: EnergyActionType): Int {
		var cost = getEnergyCost(entity, type);
		entity.fireEvent(new ConsumeEnergyEvent(cost));
		return cost;
	}

	public static function getEnergyCost(entity: Entity, type: EnergyActionType): Int {
		switch type {
			case ACT_MOVE:
				return 200;
			case ACT_WAIT:
				return 500;
			case ACT_SLEEP:
				return 1000;
			case ACT_DROP:
				return 25;
			case ACT_PICKUP:
				return 65;
			case ACT_TAKE:
				return 65;
			case ACT_EXTINGUISH:
				return 25;
			case ACT_LIGHT:
				return 150;
			case ACT_THROW:
				return 150;
			case ACT_EQUIP:
				return 80;
			case ACT_UNEQUIP:
				return 80;
			case ACT_DOOR_OPEN:
				return 80;
			case ACT_DOOR_CLOSE:
				return 80;
			case ACT_SWAPPED:
				return 25;
			case _:
				return 50;
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

			if (!world.timeStopped) {
				world.clock.incrementTick(tickAmount);
			}

			query.each((e) -> e.get(Energy).addEnergy(tickAmount));
		}

		return entity;
	}

	public override function update(frame: Frame) {
		world.clock.clearDeltas();

		if (isPlayersTurn && world.player.entity.get(Energy).hasEnergy) {
			// TODO Sleeping system logic
			return;
		}

		// TODO Most of the slowdown is happening in this loop
		while (true) {
			// Get the next entity from the query iterator
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
