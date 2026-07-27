package domain.events;

import domain.components.EquipmentSlot;
import domain.components.Weapon;
import ecs.EntityEvent;

typedef WeaponData = {
	var weapon: Weapon;
	var slot: EquipmentSlot;
}

class QueryEquippedEvent extends EntityEvent {
	public var weapons: Array<WeaponData> = new Array();

	public function new() {}

	public inline function add(weapon: Weapon, slot: EquipmentSlot) {
		weapons.push({
			weapon: weapon,
			slot: slot,
		});
	}
}
