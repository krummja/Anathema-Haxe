package prefabs;

import echoes.Entity;
import components.*;

@:build(echoes.Entity.build())
@:arguments(Position)
abstract WallPrefab(Entity) {
	public var position: Position;
	public var lightBlocker: LightBlocker = new LightBlocker();
}
