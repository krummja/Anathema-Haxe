package systems;

import components.Moved;
import components.IsDestroyed;
import components.MoveComplete;
import systems.System.Query;
import echoes.View;
import echoes.Entity;
import components.Move;
import components.Position;

class MovementSystem extends System {
	public var movers(get, never): Query;
	public var moved(get, never): Query;
	public var completed(get, never): Query;

	private var _movers = getLinkedView(Move);
	private var _moved = getLinkedView(Moved);
	private var _completed = getLinkedView(MoveComplete);

	public function finishMoveFast(entity: Entity): Bool {
		var move = entity.get(Move);

		if (move == null) {
			return false;
		}

		move.duration = 0.015;
		return true;
	}

	@:add
	private function onMoveAdded(move: Move): Void {
		move.startTime = loop.frame.elapsed;
	}

	@:update
	private function update(time: Float) {
		var frame = loop.frame;

		for (entity in completed) {
			entity.remove(MoveComplete);
		}

		for (entity in moved) {
			entity.remove(Moved);
		}

		for (entity in movers) {
			var move = entity.get(Move);

			if (!move.isMoveFired) {
				entity.add(new Moved());
				move.isMoveFired = true;
			}

			var start = move.start.toWorld();
			var target = move.goal.toWorld();

			entity.get(Position).set(target.x, target.y);
			entity.remove(move);

			// var current = entity.get(Position).asCoordinate().toWorld();
			// var distanceSq = current.distance(move.goal, WORLD, EUCLIDEAN_SQ);
			// var currentDuration = frame.elapsed - move.startTime;
			// var progress = (currentDuration / move.duration).clamp(0, 1);

			// var newPos = move.start.ease(move.goal, progress, move.ease);
			// entity.get(Position).set(newPos.x, newPos.y);

			// if (distanceSq < move.epsilon * move.epsilon) {
			// 	entity.remove(move);
			// 	entity.add(new MoveComplete());
			// }
		}
	}

	private function get_movers(): Query {
		return _movers.entities.filter((c) -> !c.exists(MoveComplete) && !c.exists(IsDestroyed));
	}

	private function get_moved(): Query {
		return _moved.entities.filter((c) -> !c.exists(IsDestroyed));
	}

	private function get_completed(): Query {
		return _completed.entities.filter((c) -> !c.exists(IsDestroyed));
	}
}
