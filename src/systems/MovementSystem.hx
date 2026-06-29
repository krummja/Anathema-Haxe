package systems;

import echoes.Entity;
import components.Move;
import components.Position;

class MovementSystem extends System {
	public function finishMoveFast(entity: Entity): Void {
		var move = entity.get(Move);
		move.duration = 0.015;
	}

	@:add private function onMoveAdded(move: Move): Void {
		move.startTime = loop.frame.elapsed;
	}

	@:update private function update(entity: Entity, position: Position, move: Move, time: Float) {
		var start = move.start.toWorld();
		var target = move.goal.toWorld();

		position.x = target.x;
		position.y = target.y;
		entity.remove(move);
	}
}
