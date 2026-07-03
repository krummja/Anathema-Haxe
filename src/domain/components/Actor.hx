package domain.components;

import ecs.Component;
import common.struct.IntPoint;
import common.struct.Coordinate;
import data.BehaviorType;

class Actor extends Component {
	public var behavior: BehaviorType;
	public var lastKnownTargetPosition: Null<Coordinate>;
	public var path: Null<Array<IntPoint>>;

	public function new(behavior: BehaviorType) {
		this.behavior = behavior;
		this.lastKnownTargetPosition = null;
		this.path = null;
	}
}
