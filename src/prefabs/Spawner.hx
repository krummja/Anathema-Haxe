package prefabs;

import echoes.Entity;
import components.Position;
import common.struct.Coordinate;
import engine.SpawnableType;

typedef SpawnFunction = (Coordinate, ?Dynamic) -> Entity;

class Spawner {
	private var prefabs: Map<SpawnableType, SpawnFunction> = new Map();

	public function new() {}

	public function initialize() {
		prefabs.set(PLAYER, (pos: Coordinate, ?options: Dynamic) -> new PlayerPrefab(new Position(pos.x, pos.y)));
		prefabs.set(BAT, (pos: Coordinate, ?options: Dynamic) -> new BatPrefab(new Position(pos.x, pos.y)));
		prefabs.set(LIGHT, (pos: Coordinate, ?options: Dynamic) -> new LightPrefab(new Position(pos.x, pos.y)));
		prefabs.set(WALL, (pos: Coordinate, ?options: Dynamic) -> new WallPrefab(new Position(pos.x, pos.y)));
	}

	public function spawn(type: SpawnableType, ?pos: Coordinate, ?options: Dynamic, ?isDetachable: Bool): Entity {
		var p = pos == null ? new Coordinate(0, 0, WORLD) : pos.toWorld().floor();
		var o = options == null ? {} : options;

		var spawnFunction = prefabs.get(type);
		var entity = spawnFunction(p, o);

		if (pos != null) {
			entity.setPosition(pos);
		}

		return entity;
	}
}
