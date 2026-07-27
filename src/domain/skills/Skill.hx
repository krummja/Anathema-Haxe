package domain.skills;

import data.AbilityType;
import domain.stats.StatMod;
import data.SkillType;

class Skill {
	public var type: SkillType;
	public var name: String;

	public function new(type: SkillType, name: String) {
		this.type = type;
		this.name = name;
	}

	public function getCost(): Int {
		return 120;
	}

	public function getStatModifiers(): Array<StatMod> {
		return [];
	}

	public function getAbilities(): Array<AbilityType> {
		return [];
	}
}
