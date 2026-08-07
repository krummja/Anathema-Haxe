package domain.stats;

import common.struct.DataRegistry;
import data.StatType;
import domain.stats.StatUnarmed.StatUnarmed;
import ecs.Entity;

typedef StatValue = {
	var stat: StatType;
	var value: Int;
}

class Stats {
	private static var stats: DataRegistry<StatType, Stat> = new DataRegistry();

	public static function init() {
		stats.register(Unarmed, new StatUnarmed());
		stats.register(Speed, new StatSpeed());
		stats.register(Cudgel, new StatCudgel());
		stats.register(Armor, new StatArmor());
		stats.register(ArmorRegen, new StatArmorRegen());
		stats.register(Dodge, new StatDodge());
		stats.register(Fortitude, new StatFortitude());
	}

	public static function get(type: StatType): Stat {
		return stats.get(type);
	}

	public static function getValue(type: StatType, entity: Entity): Int {
		return stats.get(type).compute(entity);
	}

	public static function getAll(entity: Entity): Array<StatValue> {
		return stats.map((stat) -> {
			stat: stat.type,
			value: stat.compute(entity),
		});
	}
}
