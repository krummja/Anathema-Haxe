package domain.components;

import domain.weapons.Weapons;
import domain.events.MeleeEvent;
import data.WeaponFamilyType;
import ecs.Component;

class Weapon extends Component {
	@save public var family: WeaponFamilyType;
	@save public var die: Int = 6;
	@save public var modifier: Int = 0;
	@save public var baseCost: Int = 80;
	@save public var range: Int = 1;

	public function new(family: WeaponFamilyType) {
		this.family = family;
		addHandler(MeleeEvent, onMelee);
	}

	public function onMelee(evt: MeleeEvent) {
		Weapons.get(family).doMelee(evt.attacker, evt.defender, this);
		evt.isHandled = true;
	}
}
