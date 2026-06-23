package prefabs;

import echoes.Entity;
import components.Position;
import components.Sprite;

@:build(echoes.Entity.build())
@:arguments(Position)
abstract Floor(Entity) {
	public var sprite: Sprite = new Sprite(TK_PLAYER, C_GREEN_1, C_GREEN_2, GROUND);
	public var position: Position;
}
