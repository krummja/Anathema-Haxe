package domain.components;

import domain.events.EnemyKilledEvemt.EnemyKilledEvent;
import domain.events.LevelUpEvent;
import domain.prefabs.Spawner;
import ecs.Component;
import engine.ColorKey;

class Level extends Component {
	@save public var xp(default, set): Int = 0;
	@save public var level: Int = 0;

	public var toNextLevel(get, never): Int;

	public function new(current: Int = 0) {
		level = current;
		addHandler(EnemyKilledEvent, onEnemyKilled);
	}

	private function levelUp() {
		level++;
		entity.fireEvent(new LevelUpEvent(level));

		Spawner.spawn(FLOATING_TEXT, entity.pos, {
			text: "LEVEL UP",
			color: C_BLUE_HC,
			duration: 300,
		});
	}

	private function onEnemyKilled(evt: EnemyKilledEvent) {
		if (!evt.enemy.has(Level)) {
			trace("Enemy has no level");
			return;
		}

		// TODO Proper calculation
		var gain = 20;
		xp += gain;

		Spawner.spawn(FLOATING_TEXT, entity.pos, {
			text: '+${gain}xp',
			color: C_GRAY_1,
			duration: 80,
		});
	}

	private function set_xp(value: Int): Int {
		xp = value;
		while (xp >= toNextLevel) {
			xp -= toNextLevel;
			levelUp();
		}
		return value;
	}

	private function get_toNextLevel(): Int {
		// TODO Proper calculation
		return 100;
	}
}
