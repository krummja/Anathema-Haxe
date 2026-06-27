package components;

import common.struct.Coordinate;

class Move extends Component {
	public var start: Coordinate;
	public var goal: Coordinate;

	public function new(goal: Coordinate) {
		this.goal = goal;
	}
}
