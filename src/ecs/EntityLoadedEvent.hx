package ecs;

class EntityLoadedEvent extends EntityEvent {
	public var tickDelta: Int;

	public function new(tickDelta: Int) {
		this.tickDelta = tickDelta;
	}
}
