package domain.prefabs.decorators;

import data.BehaviorType;
import data.SpawnableType;
import domain.components.*;
import ecs.Entity;

typedef CharacterOptions = {
	public var ?moniker: Null<String>;
	public var ?level: Null<Int>;
	public var ?energy: Null<Int>;
	public var ?dexterity: Null<Int>;
	public var ?behavior: Null<BehaviorType>;
	public var ?corpse: Null<SpawnableType>;
}

class BasicCharacterDecorator {
	public static function decorate(entity: Entity, options: CharacterOptions) {
		entity.add(new Moniker(options.moniker.or("Unknown")));
		entity.add(new Vision(13));
		entity.add(new Actor(options.behavior.or(Basic)));
		entity.add(new Attributes(0, options.dexterity ?? 0, 0, 0, 0, 0, 0, 0, 0));
		entity.add(new IsCreature());
		entity.add(new Energy(options.energy.or(-10)));
		entity.add(new Level(options.level.or(1)));

		var health = new Health();
		health.corpsePrefab = options.corpse;
		entity.add(health);
	}
}
