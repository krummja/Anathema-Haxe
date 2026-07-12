package domain.components;

import ecs.Component;
import common.util.Easing.EasingType;
import common.struct.Coordinate;

class Move extends Component {
	@save public var start: Coordinate;
	@save public var goal: Coordinate;
	@save public var duration: Float;
	@save public var epsilon: Float;
	@save public var ease: EasingType;
	@save public var isMoveFired: Bool;

	public var startTime: Float;

	public function new(goal: Coordinate, duration: Float = 1.0, ease: EasingType = EASE_LINEAR, epsilon: Float = 0.0025) {
		this.goal = goal;
		this.duration = duration;
		this.epsilon = epsilon;
		this.ease = ease;
		this.isMoveFired = false;
	}
}
