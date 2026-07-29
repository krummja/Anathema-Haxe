package domain.skills;

import domain.stats.StatMod;

class SkillBrawler extends Skill {
	public function new() {
		super(Striking, "Brawler");
	}

	public override function getStatModifiers(): Array<StatMod> {
		return [
			{
				source: "Brawler",
				stat: Unarmed,
				mod: 4,
			},
		];
	}
}
