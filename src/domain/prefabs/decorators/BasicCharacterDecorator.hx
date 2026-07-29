package domain.prefabs.decorators;

import ecs.Entity;
import data.BehaviorType;
import domain.components.*;

typedef CharacterOptions = {
	public var ?moniker: Null<String>;
	public var ?level: Null<Int>;
	public var ?energy: Null<Int>;
	public var ?dexterity: Null<Int>;
	public var ?behavior: Null<BehaviorType>;
}

class BasicCharacterDecorator {
	public static function decorate(entity: Entity, options: CharacterOptions) {
		entity.add(new Moniker(options.moniker.or("Unknown")));
		entity.add(new Vision(13));
		entity.add(new Actor(options.behavior.or(Basic)));
		entity.add(new Attributes(0, options.dexterity ?? 0, 0, 0, 0, 0, 0, 0, 0));
		entity.add(new IsCreature());
		entity.add(new Energy(options.energy.or(-10)));
		entity.add(new Health());
	}
}
