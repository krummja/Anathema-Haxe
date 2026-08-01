package domain.components;

import common.struct.Coordinate;
import data.SpawnableType;
import domain.events.AttackedEvent;
import domain.events.DamagedEvent;
import domain.events.EnemyKilledEvemt.EnemyKilledEvent;
import domain.events.EntitySpawnedEvent;
import domain.events.HealEvent;
import domain.prefabs.Spawner;
import domain.stats.Stats;
import ecs.Component;
import engine.ColorKey;
import engine.MainLoop;
import hxd.Rand;

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
			var rate = GameMath.getArmorRegenRatePerTurn(regenStat) / 100;
			armor += (rate * tickDelta).round().clampLower(1);
		} else if (armor > armorMax) {
			armor = armorMax;
		}
	}

	private function onEntitySpawned(evt: EntitySpawnedEvent) {
		value = max;
		armor = armorMax;
	}

	private function onAttacked(evt: AttackedEvent) {
		var r = Rand.create();
		var dodge = Stats.getValue(Dodge, entity);
		var ac = r.roll(MainLoop.getInstance().DIE_SIZE, dodge);
		var isPlayer = entity.has(IsPlayer);

		var offset = new Coordinate(16, 0, PIXEL);
		var playerText = entity.pos.sub(offset);
		var enemyText = entity.pos.add(offset);

		var textPos = isPlayer ? playerText : enemyText;

		// If critical, effective AC is 0
		if (evt.attack.isCritical) {
			ac = 0;
		}

		// If attack hit roll exceeds AC
		if (evt.attack.toHit >= ac) {
			var regenStat = Stats.getValue(ArmorRegen, entity);
			regenDelayTicks = GameMath.getArmorRegenDelay(regenStat);

			// If armor is penetrated by damage amount
			if (takeDamage(evt.attack.damage)) {
				// TODO
			}

			// entity.add(new HitBlink());
			evt.isHit = true;
			entity.fireEvent(new DamagedEvent());

			if (evt.attack.isCritical) {
				Spawner.spawn(FLOATING_TEXT, textPos, {
					text: 'crit! -' + evt.attack.damage.toString(),
					color: ColorKey.C_YELLOW_HC,
					duration: 120
				});
			} else {
				Spawner.spawn(FLOATING_TEXT, textPos, {
					text: '-' + evt.attack.damage.toString(),
					color: ColorKey.C_RED_HC,
					duration: 100
				});
			}

			var actor = entity.get(Actor);
			if (actor != null) {
				// Aggro entity on hit, essentially, by setting a target
				actor.lastKnownTargetPosition = evt.attack.attacker.pos;
			}
		} else {
			Spawner.spawn(FLOATING_TEXT, textPos, {
				text: 'dodged',
				color: ColorKey.C_BLUE_HC,
				duration: 80
			});

			evt.isHit = false;
		}

		if (_value <= 0) {
			evt.attack.attacker.fireEvent(new EnemyKilledEvent(entity));
		}
	}

	private function onHeal(evt: HealEvent) {
		value = max;
		armor = armorMax;
	}

	private function takeDamage(amount: Int): Bool {
		var remaining = armor - amount;

		if (remaining >= 0) {
			armor = remaining;
			return false;
		}

		armor = 0;
		value += remaining;
		return true;
	}

	private function set_value(value: Int): Int {
		_value = value.clamp(0, max);
		if (_value <= 0) {
			entity.add(new IsDead());
		}
		return _value;
	}

	private function get_value(): Int {
		return _value;
	}

	private function get_percent(): Float {
		return value / max;
	}

	private function get_max(): Int {
		// TODO Calculation based on relevant resilience
		// var stat = Stats.getValue()
		return 100;
	}

	private function set_armor(value: Int): Int {
		_armorValue = value.clamp(0, armorMax);
		return _armorValue;
	}

	private function get_armor(): Int {
		return _armorValue;
	}

	private function get_armorPercent(): Float {
		return _armorValue / armorMax;
	}

	private function get_armorMax(): Int {
		// TODO Calculation based on Armor stat
		return 10;
	}
}
