package domain.systems;

import data.EnergyActionType;
import domain.components.*;
import domain.events.ConsumeEnergyEvent;
import domain.stats.Stats;
import ecs.Entity;
import ecs.Query;
import ecs.System;
import engine.Frame;

class EnergySystem extends System {
	public static function consumeEnergy(entity: Entity, type: EnergyActionType): Int {
		var cost = getEnergyCost(entity, type);
		entity.fireEvent(new ConsumeEnergyEvent(cost));
		return cost;
	}

	public static function getEnergyCost(entity: Entity, type: EnergyActionType): Int {
		return switch type {
			case ACT_MOVE:
				var speed = Stats.getValue(Speed, entity);
				GameMath.getMoveCost(speed);
			case ACT_WAIT:
				100;
			case ACT_SLEEP:
				1000;
			case ACT_DROP:
				25;
			case ACT_PICKUP:
				65;
			case ACT_TAKE:
				65;
			case ACT_EXTINGUISH:
				25;
			case ACT_LIGHT:
				150;
			case ACT_THROW:
				150;
			case ACT_EQUIP:
				80;
			case ACT_UNEQUIP:
				80;
			case ACT_DOOR_OPEN:
				80;
			case ACT_DOOR_CLOSE:
				80;
			case ACT_SWAPPED:
				25;
			case _:
				50;
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
