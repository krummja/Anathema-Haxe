package domain.components;

import ecs.Component;

class Vision extends Component {
	public var range: Int;

	public function new(range: Int = 6) {
		this.range = range;
	}
}
