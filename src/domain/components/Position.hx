package domain.components;

import ecs.Component;
import common.struct.Coordinate;

class Position extends Component {
	public var x: Float = 0.0;
	public var y: Float = 0.0;

	public function new(x: Float, y: Float) {
		this.x = x;
		this.y = y;
	}

	public function set(x: Float, y: Float) {
		this.x = x;
		this.y = y;
	}

	public function asCoordinate(space: CoordinateSpace = WORLD): Coordinate {
		return new Coordinate(this.x, this.y, space);
	}
}
