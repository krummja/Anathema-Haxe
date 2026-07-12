package engine;

import common.algorithm.Distance;
import common.algorithm.AStar;
import common.algorithm.AStar.AStarResult;
import common.struct.Coordinate;
import domain.components.*;
import domain.systems.EnergySystem;
import ecs.Entity;

class Behavior {
	public var world(get, never): domain.World;

	public function takeAction(entity: Entity): Void {
		wait(entity);
	}

	public function wait(entity: Entity): Void {
		EnergySystem.consumeEnergy(entity, ACT_WAIT);
	}

	public function tryMoveToward(entity: Entity, goal: Coordinate, dist: Int = 0): Bool {
		var path = astar(entity, goal);

		if (!path.success) {
			return false;
		}

		if (path.path.length <= dist) {
			wait(entity);
			return true;
		}

		var next = path.path[1];

		if (next == null) {
			return false;
		}

		var entities = world.getEntitiesAt(next);

		if (Lambda.exists(entities, (e) -> e.has(IsCreature))) {
			wait(entity);
			return true;
		}

		EnergySystem.consumeEnergy(entity, ACT_MOVE);

		var fast = entity.has(Move);
		entity.add(new Move(next.asWorld(), fast ? 0.1 : 0.2, EASE_LINEAR));

		return true;
	}

	public function getTarget(entity: Entity): Null<Entity> {
		var visible = getVisibleTargets(entity);
		return visible.length > 0 ? visible.first() : null;
	}

	public function getVisibleTargets(entity: Entity): Array<Entity> {
		var factions = MainLoop.getInstance().world.factions;
		var vision = entity.get(Vision);

		if (vision == null) {
			return [];
		}

		// TODO This is causing _extreme_ slowdowns
		// Would it help to pre-filter the entities list to candidates based on the behavior?
		// In this method, I'm looking through every visible cell and checking every entity
		// to see if there are any valid targets in vision range.
		//
		// I can probably reduce this enormously by keeping a distance graph of entities,
		// then just get the entities that match the requested visual range.
		//
		// Additionally, I can filter out entities that don't fit the behavior criteria,
		// e.g. there's no reason for an enemy to constantly search for things to attack.
		// Rather, they should respond to an event (something has entered its territory)
		// and then respond with appropriate logic (territory breached -> defensive behavior
		// -> looking for enemies and not allies).

		var distances = MainLoop.getInstance().world.getEntityDistances(entity.pos.toIntPoint());

		var inRange = [];

		for (distance in distances) {
			if (distance.d <= vision.range) {
				// var target = MainLoop.getInstance().registry.getEntity(distance.id);
				inRange.push(distance);
			}
		}

		inRange.sort((a, b) -> a.d < b.d ? 1 : -1);

		var inRangeEntities = [];
		for (entry in inRange) {
			var target = MainLoop.getInstance().registry.getEntity(entry.id);
			inRangeEntities.push(target);
		}

		var targets = inRangeEntities.filter((e) -> {
			var canSee = MainLoop.getInstance().world.systems.vision.canSee(entity, e.pos) && e != entity;
			var isHostile = factions.areEntitiesHostile(e, entity);
			return canSee && isHostile;
		});

		return targets;
	}

	public function astar(entity: Entity, goal: Coordinate): AStarResult {
		return AStar.getPath({
			start: entity.pos.toWorld().toIntPoint(),
			goal: goal.toWorld().toIntPoint(),
			maxDepth: 250,
			allowDiagonals: true,
			cost: (a, b) -> {
				if (world.isOutOfBounds(b)) {
					return Math.POSITIVE_INFINITY;
				}

				var entities = world.getEntitiesAt(b);

				if (entities.exists((e) -> e.has(Collider))) {
					return Math.POSITIVE_INFINITY;
				}

				var distance = Distance.Diagonal(a, b);

				if (entities.exists((e) -> e.has(IsCreature) || e.has(IsPlayer))) {
					return distance * 5;
				}

				return distance;
			}
		});
	}

	private function get_world(): domain.World {
		return MainLoop.getInstance().world;
	}
}
