package domain.prefabs;

import common.struct.Coordinate;
import domain.components.*;
import domain.prefabs.decorators.BasicCharacterDecorator;
import ecs.Entity;

class BatPrefab extends Prefab {
	public function create(options: Dynamic, pos: Coordinate): Entity {
		var entity = new Entity(pos);

		entity.add(new Sprite(TK_BAT_01, C_GRAY_1, C_RED_0, ACTOR));
		entity.add(new FactionMember(FACTION_WILDLIFE));

		BasicCharacterDecorator.decorate(entity, {
			moniker: "Bat",
			level: 1,
			behavior: Zombie,
			dexterity: 5,
			corpse: CORPSE,
		});

		entity.add(new EquipmentSlot("head", "face", Hand, true));
		entity.get(EquipmentSlot).equip(Spawner.spawn(STICK, pos));

		return entity;
	}
}
