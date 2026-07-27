package domain.prefabs;

import domain.prefabs.decorators.BasicCharacterDecorator;
import ecs.Entity;
import common.struct.Coordinate;
import domain.components.*;

class BatPrefab extends Prefab {
	public function create(options: Dynamic, pos: Coordinate): Entity {
		var entity = new Entity(pos);

		entity.add(new Sprite(TK_BAT_01, C_GRAY_1, C_RED_0, ACTOR));
		entity.add(new FactionMember(FACTION_WILDLIFE));

		BasicCharacterDecorator.decorate(entity, {
			moniker: "Bat",
			behavior: Zombie,
		});

		entity.add(new EquipmentSlot("head", "face", Hand, true));
		entity.get(EquipmentSlot).equip(Spawner.spawn(STICK, pos));

		return entity;
	}
}
