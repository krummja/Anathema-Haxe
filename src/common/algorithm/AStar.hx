package common.algorithm;

import common.struct.PriorityQueue;
import common.algorithm.Distance.DistanceFormula;
import common.struct.IntPoint;

typedef AStarSettings = {
	var start: IntPoint;
	var goal: IntPoint;
	var allowDiagonals: Bool;
	var cost: (current: IntPoint, next: IntPoint) -> Float;
	var ?maxDepth: Null<Int>;
}

typedef AStarResult = {
	var success: Bool;
	var path: Array<IntPoint>;
	var costs: Array<Float>;
	var cost: Float;
	var start: IntPoint;
	var goal: IntPoint;
}

class AStar {
	public static function getPath(settings: AStarSettings): AStarResult {
		var heuristic: DistanceFormula = settings.allowDiagonals ? DIAGONAL : MANHATTAN;
		var start = settings.start;
		var goal = settings.goal;
		var cost = settings.cost;
		var maxDepth = settings.maxDepth.or(10_000);
		var depth = 0;

		var open = new PriorityQueue<{key: String, pos: IntPoint}>();
		var from = new Map<String, IntPoint>();
		var costs = new Map<String, Float>();

		var startKey = key(start);
		var goalKey = key(goal);

		var result: AStarResult = {
			success: false,
			path: new Array(),
			costs: new Array(),
			cost: Math.POSITIVE_INFINITY,
			start: start,
			goal: goal,
		};

		if (cost(start, goal) == Math.POSITIVE_INFINITY) {
			return result;
		}

		open.put({
			key: startKey,
			pos: start,
		}, 0);

		costs[startKey] = 0;

		while (!open.isEmpty) {
			depth++;

			if (depth >= maxDepth) {
				break;
			}

			var d = open.pop();
			var current = d.pos;
			var currentKey = d.key;

			if (currentKey == goalKey) {
				result.success = true;
				break;
			}

			var neighbors = neighbors(current, settings.allowDiagonals);

			for (next in neighbors) {
				var nextKey = key(next);
				var graphCost = nextKey == goalKey ? 0 : cost(current, next);

				if (graphCost == Math.POSITIVE_INFINITY) {
					continue;
				}

				var newCost = costs[currentKey] + graphCost;

				if (!costs.exists(nextKey) || newCost < costs[nextKey]) {
					costs[nextKey] = newCost;

					var priority = newCost + Distance.Get(next, goal, heuristic);

					open.put({
						key: nextKey,
						pos: next,
					}, priority);

					from[nextKey] = current;
				}
			}
		}

		if (!result.success) {
			return result;
		}

		result.path = [goal];
		result.cost = costs[goalKey];
		result.costs = [costs[goalKey]];

		var previous = from[key(goal)];

		while (previous != null) {
			var previousKey = key(previous);
			result.path.unshift(previous);
			result.costs.unshift(costs[previousKey]);
			previous = from[previousKey];
		}

		return result;
	}

	private inline static function key(point: IntPoint): String {
		return '${point.x},${point.y}';
	}

	private inline static function neighbors(point: IntPoint, allowDiagnonals: Bool): Array<IntPoint> {
		var x = point.x;
		var y = point.y;

		var _neighbors: Array<IntPoint> = [
			{x: x, y: y - 1},
			{x: x, y: y + 1},
			{x: x - 1, y: y},
			{x: x + 1, y: y},
		];

		if (allowDiagnonals) {
			_neighbors.push({x: x - 1, y: y - 1});
			_neighbors.push({x: x + 1, y: y - 1});
			_neighbors.push({x: x - 1, y: y + 1});
			_neighbors.push({x: x + 1, y: y + 1});
		}

		return _neighbors;
	}
}
