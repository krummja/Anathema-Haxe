package events;

import echoes.Entity;
import common.struct.Coordinate;
import engine.EntityEvent;

class MovedEvent extends EntityEvent {
	public var pos: Coordinate;
	public var mover: Entity;

	public function new(mover: Entity, pos: Coordinate) {
		this.mover = mover;
		this.pos = pos;
	}
}
