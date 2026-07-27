package domain.abilities;

import ecs.Entity;
import data.AbilityModeType;
import data.AbilityType;

class Ability {
	public var type: AbilityType;
	public var mode: AbilityModeType;
	public var name: String;

	public function new(type: AbilityType, mode: AbilityModeType, name: String) {
		this.type = type;
		this.mode = mode;
		this.name = name;
	}

	public function getDescription(entity: Entity): String {
		return "[Ability Description]";
	}

	public function requirementsMet(entity: Entity): Bool {
		return true;
	}

	public function initiate(entity: Entity) {}
}
