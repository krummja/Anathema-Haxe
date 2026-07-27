package domain.stats;

import ecs.Entity;
import domain.stats.StatUnarmed.StatUnarmed;
import common.struct.DataRegistry;
import data.StatType;

typedef StatValue = {
	var stat: StatType;
	var value: Int;
}

class Stats {
	private static var stats: DataRegistry<StatType, Stat> = new DataRegistry();

	public static function init() {
		stats.register(Unarmed, new StatUnarmed());
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
