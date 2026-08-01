package domain.weapons;

import data.StatType;
import data.footprints.Footprint;
import data.footprints.PointFootprint;
import domain.components.Weapon;
import domain.events.AttackedEvent;
import domain.events.ConsumeEnergyEvent;
import domain.stats.Stats;
import ecs.Entity;
import engine.MainLoop;
import hxd.Rand;

class WeaponFamily {
	public var isRanged: Bool;
	public var stat: StatType;

	public function getMeleeAttacks(attacker: Entity, weapon: Weapon): Array<Attack> {
		var r = Rand.create();
		var roll = r.roll(MainLoop.getInstance().DIE_SIZE);
		var toHit = roll + GameMath.getMeleeAttackToHit(attacker, weapon);
		var stat = Stats.getValue(stat, attacker);
		var damage = r.roll(weapon.die, weapon.modifier) + stat;
		var isCritical = roll == MainLoop.getInstance().DIE_SIZE;

		return [
			{
				attacker: attacker,
				toHit: toHit,
				damage: damage,
				damageType: Crushing,
				isCritical: isCritical,
				defender: null,
			}
		];
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
