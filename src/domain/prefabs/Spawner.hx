package domain.prefabs;

import engine.MainLoop;
import engine.SpawnableType;
import domain.events.EntitySpawnedEvent;
import common.struct.Coordinate;

class Spawner {
	private var prefabs: Map<SpawnableType, Prefab> = new Map();

	public function new() {}

	public function initialize() {
		prefabs.set(PLAYER, new PlayerPrefab());
		prefabs.set(LIGHT, new LampPrefab());
		prefabs.set(TALL_GRASS, new PlantPrefab());
	}

	public function spawnEntity(type: SpawnableType, ?pos: Coordinate, ?options: Dynamic, ?isDetachable: Bool) {
		var p = pos == null ? new Coordinate(0, 0, WORLD) : pos.toWorld().floor();
		var o = options == null ? {} : options;
		var d = isDetachable == null ? false : isDetachable;

		var entity = prefabs.get(type).create(o, p);

		if (d) {
			entity.isDetachable = true;
		}

		entity.pos = p;
		entity.fireEvent(new EntitySpawnedEvent());
		return entity;
	}

	public static function spawn(type: SpawnableType, ?pos: Coordinate, ?options: Dynamic, ?isDetachable: Bool) {
		return MainLoop.getInstance().world.spawner.spawnEntity(type, pos, options, isDetachable);
	}
}
