package components;

import common.util.Easing.EasingType;
import common.struct.Coordinate;

class Move {
	public var start: Coordinate;
	public var goal: Coordinate;
	public var duration: Float;
	public var epsilon: Float;
	public var ease: EasingType;

	public var startTime: Float;

	public function new(goal: Coordinate, duration: Float = 1.0, ease: EasingType = EASE_LINEAR, epsilon: Float = 0.0025) {
		this.goal = goal;
		this.duration = duration;
		this.epsilon = epsilon;
		this.ease = ease;
	}
}
