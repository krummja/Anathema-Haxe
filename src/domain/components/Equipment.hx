package domain.components;

import domain.events.QueryInteractionsEvent;
import domain.events.UnequipEvent;
import domain.events.EquipEvent;
import data.EquipmentSlotType;
import ecs.Component;

class Equipment extends Component {
	@save public var slotTypes: Array<EquipmentSlotType> = [];
	@save public var extraSlotTypes: Array<EquipmentSlotType> = [];

	public function new(slotTypes: Array<EquipmentSlotType>, ?extraSlotTypes: Array<EquipmentSlotType>) {
		this.slotTypes = slotTypes;
		this.extraSlotTypes = extraSlotTypes.or([]);

		addHandler(EquipEvent, onEquip);
		addHandler(UnequipEvent, onUnequip);
		addHandler(QueryInteractionsEvent, onQueryInteractions);
	}

	public function unequip() {}

	private function onEquip(evt: EquipEvent) {}

	private function onUnequip(evt: UnequipEvent) {}

	private function onQueryInteractions(evt: QueryInteractionsEvent) {}
}
