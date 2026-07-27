package domain.weapons;

import data.DamageType;
import ecs.Entity;

typedef Attack = {
	var attacker: Entity;
	var toHit: Int;
	var damage: Int;
	var damageType: DamageType;
	var isCritical: Bool;
	var defender: Null<Entity>;
}
