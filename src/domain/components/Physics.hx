package domain.components;

import ecs.Component;

class Phystics extends Component {
	public var isReal(default, null): Bool;
	public var solid(default, null): Bool;
	public var weight(default, null): Int;

	public function new(isReal: Bool = true, solid: Bool = false, weight: Int = 0) {
		this.isReal = isReal;
		this.solid = solid;
		this.weight = weight;
	}
}
