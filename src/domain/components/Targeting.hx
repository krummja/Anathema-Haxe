package domain.components;

import ecs.Component;
import ecs.Entity;

class Targeting extends Component {
	public var target: Entity;

	public function new(target: Entity) {
		this.target = target;
	}
}
