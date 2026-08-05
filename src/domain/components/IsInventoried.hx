package domain.components;

import domain.events.MovedEvent;
import ecs.Component;
import ecs.Entity;

class IsInventoried extends Component {
	@save private var holderId: String;

	public var holder(get, set): Null<Entity>;

	public function new(holderId: String) {
		this.holderId = holderId;
		addHandler(MovedEvent, onMoved);
	}

	private function onMoved(evt: MovedEvent) {
		if (evt.mover.id != entity.id) {
			entity.pos = evt.pos;
		}
	}

	private function get_holder(): Null<Entity> {
		return entity.registry.getEntity(holderId);
	}

	private function set_holder(value: Entity): Entity {
		holderId = entity.id;
		return value;
	}
}
