package domain.components;

import data.SpawnableType;
import domain.events.AttackedEvent;
import domain.events.EntitySpawnedEvent;
import domain.events.HealEvent;
import domain.stats.Stats;
import ecs.Component;

class Health extends Component {
	@save public var regenDelayTicks: Int = 10;
	@save public var corpsePrefab: SpawnableType;

	@save private var _value: Int = 10;
	@save private var _armorValue: Int = 10;

	public var value(get, set): Int;
	public var max(get, never): Int;
	public var percent(get, never): Float;

	public var armor(get, set): Int;
	public var armorMax(get, never): Int;
	public var armorPercent(get, never): Float;

	public function new() {
		addHandler(EntitySpawnedEvent, onEntitySpawned);
		addHandler(AttackedEvent, onAttacked);
		addHandler(HealEvent, onHeal);
	}

	public function toString(): String {
		return '${value}/${max} (${armor}/${armorMax})';
	}

	public function onTickDelta(tickDelta: Int) {
		regenDelayTicks -= tickDelta;

		if (armor < armorMax && regenDelayTicks <= 0) {
			regenDelayTicks = 0;

			var regenStat = Stats.getValue(ArmorRegen, entity);
			// var rate = GameMath
			// TODO
		}
	}

	private function onEntitySpawned(evt: EntitySpawnedEvent) {
		value = max;
		armor = armorMax;
	}

	private function onAttacked(evt: AttackedEvent) {}

	private function onHeal(evt: HealEvent) {}

	private function set_value(value: Int): Int {
		return value;
	}

	private function get_value(): Int {
		return _value;
	}

	private function get_percent(): Float {
		return value / max;
	}

	private function get_max(): Int {
		return 0;
	}

	private function set_armor(value: Int): Int {
		return value;
	}

	private function get_armor(): Int {
		return _armorValue;
	}

	private function get_armorPercent(): Float {
		return _armorValue / armorMax;
	}

	private function get_armorMax(): Int {
		return 0;
	}
}
