package prefabs;

import echoes.Entity;
import components.Actor;
import components.Position;
import components.Energy;
import components.Sprite;

@:build(echoes.Entity.build())
@:arguments(Position)
abstract BatPrefab(Entity) {
	public var sprite: Sprite = new Sprite(TK_BAT_01, C_WHITE, C_BLUE_1, ACTOR);
	public var energy: Energy = new Energy(-10);
	public var actor: Actor = new Actor(BHV_BASIC);
	public var position: Position;
}
