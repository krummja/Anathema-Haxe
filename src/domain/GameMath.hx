package domain;

import domain.components.Weapon;
import domain.stats.Stats;
import domain.weapons.Weapons;
import ecs.Entity;

class GameMath {
	public static var XP_REQ_CAP = 4000;
	public static var XP_LVL_INTENSITY = 10;
	public static var XP_BASE_GAIN = 120;
	public static var XP_SPREAD = 8;
	public static var XP_POWER = 3;

	public static function getMaxHealth(level: Int, fortitudeStat: Int): Int {
		return 10 + level * 10 + fortitudeStat * 10;
	}

	public static function getAttributePointTotal(level: Int): Int {
		return 7 + level;
	}

	public static function getMoveCost(speedStat: Int): Int {
		return 100 - (speedStat * 2);
	}

	public static function getArmorRegenRatePerTurn(armorRegenStat: Int): Int {
		return 4 + armorRegenStat;
	}

	public static function getArmorRegenDelay(armorRegenStat: Int): Int {
		return 800;
	}

	public static function getMeleeAttackToHit(attacker: Entity, weapon: Weapon) {
		var weaponFamily = Weapons.get(weapon.family);

		// TODO Should this stats get be in this method?
		// TODO Make the to-hit dynamic instead of flat +6
		return Stats.getValue(weaponFamily.stat, attacker) + 6;
	}
}
