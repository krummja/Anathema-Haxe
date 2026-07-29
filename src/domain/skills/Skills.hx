package domain.skills;

import common.struct.DataRegistry;
import data.SkillType;

class Skills {
	private static var skills: DataRegistry<SkillType, Skill> = new DataRegistry();

	public static function init() {
		skills.register(Striking, new SkillBrawler());
	}

	public static function get(type: SkillType): Skill {
		return skills.get(type);
	}

	public static function getAll(): Array<Skill> {
		return skills.getAll();
	}
}
