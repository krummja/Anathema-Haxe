package domain.components;

import domain.events.EntitySpawnedEvent;
import ecs.Component;
import common.struct.IntPoint;
import common.struct.Coordinate;
import data.BehaviorType;

class Actor extends Component {
	@save public var behavior: BehaviorType;
	@save public var lastKnownTargetPosition: Null<Coordinate>;
	@save public var path: Null<Array<IntPoint>>;
	@save public var leashPosition: Null<Coordinate>;
	@save public var leashDistance: Int;
	@save public var isReturningToLeash: Bool;

	public function new(behavior: BehaviorType) {
		this.behavior = behavior;
		this.lastKnownTargetPosition = null;
		this.path = null;
		this.leashDistance = 25;
		this.isReturningToLeash = false;

		addHandler(EntitySpawnedEvent, onEntitySpawned);
	}

	private function onEntitySpawned(evt: EntitySpawnedEvent) {
		this.leashPosition = entity.pos;
	}
}
