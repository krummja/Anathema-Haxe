package domain.prefabs;

import domain.components.EquipmentSlot;
import domain.components.FactionMember;
import domain.components.Moniker;
import domain.components.Vision;
import domain.components.Energy;
import domain.components.IsPlayer;
import domain.components.Sprite;
import ecs.Entity;
import common.struct.Coordinate;

class PlayerPrefab extends Prefab {
	public function create(options: Dynamic, pos: Coordinate) {
		var entity = new Entity(pos);

		entity.add(new Sprite(TK_PLAYER_01, C_WHITE, C_BLUE_1, PLAYER));
		entity.add(new IsPlayer());
		entity.add(new Energy(10));
		entity.add(new Vision(40));
		entity.add(new Moniker("Player"));
		entity.add(new FactionMember(FACTION_PLAYER));

		var rhand = new EquipmentSlot("Right hand", "handRight", Hand, true);
		entity.add(rhand);

		rhand.equip(Spawner.spawn(STICK, pos));

		return entity;
	}
}
