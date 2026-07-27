package domain.components;

import common.struct.Coordinate;
import common.util.Easing.EasingType;
import common.struct.Cardinal;
import ecs.Component;

class Attacker extends Component {
	@save public var direction: Cardinal;
	@save public var duration: Float;
	@save public var ease: EasingType;

	public var startPos: Coordinate;
	public var startTime: Float;

	public function new(direction: Cardinal, duration: Float = 0.1, ease: EasingType = EASE_LINEAR) {
		this.direction = direction;
		this.duration = duration;
		this.ease = ease;
	}
}
