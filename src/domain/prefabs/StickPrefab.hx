package domain.prefabs;

import domain.components.Equipment;
import common.struct.Coordinate;
import domain.components.Weapon;
import domain.components.Moniker;
import ecs.Entity;

class StickPrefab extends Prefab {
	public function create(options: Dynamic, pos: Coordinate) {
		var entity = new Entity(pos);

		entity.add(new Moniker("Stick"));
		entity.add(new Equipment([Hand]));
		entity.add(new Weapon(Cudgel));

		return entity;
	}
}
