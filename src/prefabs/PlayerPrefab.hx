package prefabs;

import echoes.Entity;
import components.Position;
import components.Ident;
import components.IsPlayer;
import components.Sprite;
import components.Energy;

@:build(echoes.Entity.build())
@:arguments(Position)
abstract PlayerPrefab(Entity) {
	public var position: Position;

	public var sprite: Sprite = new Sprite(TK_PLAYER_01, C_WHITE, C_BLUE_1, ACTOR);
	public var isPlayer: IsPlayer = new IsPlayer();
	public var energy: Energy = new Energy(10);
}
