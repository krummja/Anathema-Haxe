package engine;

import components.Move;
import components.IsCreature;
import components.Position;
import common.algorithm.Distance;
import common.algorithm.AStar;
import common.algorithm.AStar.AStarResult;
import common.struct.Coordinate;
import systems.EnergySystem;
import echoes.Entity;

class Behavior {
	public var world(get, never): World;

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

		if (Lambda.exists(entities, (e) -> e.exists(IsCreature))) {
			wait(entity);
			return true;
		}

		EnergySystem.consumeEnergy(entity, ACT_MOVE);

		var fast = entity.exists(Move);
		entity.add(new Move(next.asWorld(), fast ? 0.1 : 0.2, EASE_LINEAR));

		return false;
	}

	public function astar(entity: Entity, goal: Coordinate): AStarResult {
		return AStar.getPath({
			start: entity.get(Position).asCoordinate().toWorld().toIntPoint(),
			goal: goal.toWorld().toIntPoint(),
			maxDepth: 250,
			allowDiagonals: true,
			cost: (a, b) -> {
				var distance = Distance.Diagonal(a, b);
				return distance;
			}
		});
	}

	private function get_world(): World {
		return MainLoop.getInstance().world;
	}
}
