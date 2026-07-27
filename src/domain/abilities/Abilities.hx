package domain.abilities;

import data.AbilityType;
import common.struct.DataRegistry;

class Abilities {
	private static var abilities: DataRegistry<AbilityType, Ability> = new DataRegistry();

	public static function init() {
		abilities.register(Sprint, new AbilitySprint());
	}

	public static function get(ability: AbilityType): Ability {
		return abilities.get(ability);
	}
}
