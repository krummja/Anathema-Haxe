package domain.abilities;

import ecs.Entity;

class AbilitySprint extends Ability {
	public function new() {
		super(Sprint, Activated, "Sprint");
	}

	public override function getDescription(entity: Entity): String {
		return "Move at increased speed.";
	}

	public override function requirementsMet(entity: Entity): Bool {
		return true;
	}

	public override function initiate(entity: Entity) {}
}
