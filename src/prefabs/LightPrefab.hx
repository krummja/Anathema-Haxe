package prefabs;

import echoes.Entity;
import components.*;

@:build(echoes.Entity.build())
@:arguments(Position)
abstract LightPrefab(Entity) {
	public var position: Position;
	public var lightSource: LightSource = new LightSource(2, 0xffffff, 4, true);
}
