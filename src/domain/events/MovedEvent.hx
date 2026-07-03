package domain.events;

import ecs.Entity;
import ecs.EntityEvent;
import common.struct.Coordinate;

class MovedEvent extends EntityEvent {
	public var pos: Coordinate;
	public var mover: Entity;

	public function new(mover: Entity, pos: Coordinate) {
		this.mover = mover;
		this.pos = pos;
	}
}
