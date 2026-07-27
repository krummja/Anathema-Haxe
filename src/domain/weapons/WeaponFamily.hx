package domain.weapons;

import hxd.Rand;
import ecs.Entity;
import engine.MainLoop;
import data.StatType;
import data.footprints.PointFootprint;
import data.footprints.Footprint;
import domain.events.AttackedEvent;
import domain.events.ConsumeEnergyEvent;
import domain.components.Weapon;

class WeaponFamily {
	public var isRanged: Bool;
	public var stat: StatType;

	public function getMeleeAttacks(attacker: Entity, weapon: Weapon): Array<Attack> {
		var r = Rand.create();
		var attacks = new Array<Attack>();

		var roll = r.roll(MainLoop.getInstance().DIE_SIZE);

		return attacks;
	}

	public function getFootprint(): Footprint {
		return new PointFootprint();
	}

	public function doMelee(attacker: Entity, defender: Entity, weapon: Weapon) {
		getMeleeAttacks(attacker, weapon).each((attack: Attack) -> {
			defender.fireEvent(new AttackedEvent(attack));
		});

		attacker.fireEvent(new ConsumeEnergyEvent(weapon.baseCost));
	}
}
