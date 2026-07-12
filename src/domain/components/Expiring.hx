package domain.components;

import ecs.Component;

class Expiring extends Component {
	public var lifetime: Float;
	public var duration: Float;

	public function new(duration: Float) {
		this.duration = duration;
		this.lifetime = 0;
	}
}
