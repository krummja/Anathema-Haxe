package domain.components;

import ecs.Component;
import common.struct.IntPoint;
import common.struct.Coordinate;
import data.BehaviorType;

class Actor extends Component {
	@save public var behavior: BehaviorType;
	@save public var lastKnownTargetPosition: Null<Coordinate>;
	@save public var path: Null<Array<IntPoint>>;

	public function new(behavior: BehaviorType) {
		this.behavior = behavior;
		this.lastKnownTargetPosition = null;
		this.path = null;
	}
}
