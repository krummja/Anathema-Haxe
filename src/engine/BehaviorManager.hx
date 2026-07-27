package engine;

import common.tools.Performance;
import ecs.Entity;
import common.struct.DataRegistry;
import domain.systems.EnergySystem;
import domain.components.Actor;
import data.BehaviorType;
import data.behaviors.BehaviorZombie;
import data.behaviors.BehaviorBasic;

class Behaviors {
	public static var behaviors: DataRegistry<BehaviorType, Behavior>;

	public static function init() {
		behaviors = new DataRegistry();

		behaviors.register(Basic, new BehaviorBasic());
		behaviors.register(Zombie, new BehaviorZombie());
	}

	public static function get(type: BehaviorType): Behavior {
		return behaviors.get(type);
	}
}

class BehaviorManager {
	public function new() {}

	public function takeAction(entity: Entity): Void {
		var actor = entity.get(Actor);

		if (actor == null) {
			trace("Energy without Actor component!");
			EnergySystem.consumeEnergy(entity, ACT_WAIT);
		}

		var behavior = Behaviors.get(actor.behavior);
		behavior.takeAction(entity);
	}
}
