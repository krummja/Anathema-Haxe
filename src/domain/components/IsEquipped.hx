package domain.components;

import domain.events.MovedEvent;
import ecs.Entity;
import ecs.Component;

class IsEquipped extends Component {
	@save public var slotKey(default, null): String;
	@save public var extraSlotKey(default, null): String;

	@save private var holderId: String;

	public var holder(get, set): Null<Entity>;
	public var slot(get, never): EquipmentSlot;
	public var extraSlot(get, never): EquipmentSlot;
	public var slotDisplay(get, never): String;

	public function new(holderId: String, slotKey: String, ?extraSlotKey: String) {
		this.holderId = holderId;
		this.slotKey = slotKey;
		this.extraSlotKey = extraSlotKey;

		addHandler(MovedEvent, onMoved);
	}

	private function onMoved(evt: MovedEvent) {}

	private function get_holder(): Null<Entity> {
		return entity.registry.getEntity(holderId);
	}

	private function set_holder(value: Entity): Entity {
		holderId = value.id;
		return value;
	}

	private function get_slot(): EquipmentSlot {
		return holder.getAll(EquipmentSlot).find((s) -> s.slotKey == slotKey);
	}

	private function get_extraSlot(): EquipmentSlot {
		return holder.getAll(EquipmentSlot).find((s) -> s.slotKey == extraSlotKey);
	}

	private function get_slotDisplay(): String {
		if (extraSlot != null) {
			return '${slot.name}, ${extraSlot.name}';
		}
		return '${slot.name}';
	}
}
