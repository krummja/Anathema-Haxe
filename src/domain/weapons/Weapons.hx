package domain.weapons;

import data.WeaponFamilyType;

class Weapons {
	private static var families: Map<WeaponFamilyType, WeaponFamily> = new Map();

	public static function init() {
		families.set(Unarmed, new WeaponFamilyUnarmed());
		families.set(Cudgel, new WeaponFamilyCudgel());
	}

	public static function get(family: WeaponFamilyType): WeaponFamily {
		return families.get(family);
	}
}
