package engine;

import common.algorithm.AStar;
import common.algorithm.Distance;
import common.struct.Coordinate;
import domain.components.*;
import domain.events.MeleeEvent;
import domain.systems.EnergySystem;
import ecs.Entity;

class Behavior {
	public var world(get, never): domain.World;

	public function new() {}

	public function takeAction(entity: Entity): Void {
		wait(entity);
	}

	public function wait(entity: Entity): Void {
		EnergySystem.consumeEnergy(entity, ACT_WAIT);
	}

	public function tryAttackingNearby(entity: Entity): Bool {
		var entityPos = entity.pos.toIntPoint();
		var factions = world.factions;
		var neighbors = world.getNeighborEntities(entityPos);
		var target = neighbors.flatten().find((e) -> factions.areEntitiesHostile(e, entity));

		if (target == null) {
			return false;
		}

		var melee = new MeleeEvent(target, entity);
		entity.fireEvent(melee);

		var offset = target.pos.toIntPoint().sub(entityPos);
		var dir = offset.toCardinal();

		entity.add(new Attacker(dir));
		return melee.isHandled;
	}

	public function tryMoveToward(entity: Entity, goal: Coordinate, dist: Int = 0): Bool {
		var path = astar(entity, goal);

		var entityName = entity.get(Moniker).displayName;

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

		if (entities.exists((e) -> e.has(IsCreature))) {
			wait(entity);
			return true;
		}

		EnergySystem.consumeEnergy(entity, ACT_MOVE);

		var fast = entity.has(Move);
		entity.add(new Move(next.asWorld(), fast ? 0.1 : 0.2, EASE_INSTANT));

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

		var inRange = world.getEntitiesInRange(entity.pos.toIntPoint(), vision.range);
		var targets = inRange.filter((e) -> {
			return e.has(Health) && factions.areEntitiesHostile(e, entity) && world.systems.vision.canSee(entity, e.pos);
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
