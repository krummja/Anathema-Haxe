package prefabs;

import echoes.Entity;
import components.Position;
import components.Ident;
import components.Sprite;

@:build(echoes.Entity.build())
@:arguments(Ident, Position)
abstract FloorPrefab(Entity) {
	public var ident: Ident;
	public var position: Position;

	public var sprite: Sprite = new Sprite(TK_TILES_01, C_GREEN_1, C_CLEAR, GROUND);
}
