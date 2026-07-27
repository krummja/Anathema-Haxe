package domain.prefabs;

import domain.components.IsCreature;
import engine.MainLoop;
import data.SpawnableType;
import domain.events.EntitySpawnedEvent;
import common.struct.Coordinate;
import domain.components.Moniker;

class Spawner {
	private var prefabs: Map<SpawnableType, Prefab> = new Map();

	public function new() {}

	public function initialize() {
		prefabs.set(PLAYER, new PlayerPrefab());
		prefabs.set(LIGHT, new LampPrefab());
		prefabs.set(TALL_GRASS, new PlantPrefab());
		prefabs.set(BAT, new BatPrefab());
		prefabs.set(BLANK, new BlankPrefab());
		prefabs.set(DEBUG, new DebugPrefab());
		prefabs.set(WALL, new WallPrefab());
		prefabs.set(STICK, new StickPrefab());
	}

	public function spawnEntity(type: SpawnableType, ?pos: Coordinate, ?options: Dynamic, ?isDetachable: Bool) {
		var p = pos == null ? new Coordinate(0, 0, WORLD) : pos.toWorld().floor();
		var o = options == null ? {} : options;
		var d = isDetachable == null ? false : isDetachable;

		var entity = prefabs.get(type).create(o, p);

		var name = entity.get(Moniker).displayName;
		if (entity.has(IsCreature)) {
			trace('Spawned ${name} (${entity.id}) at (${pos.x}, ${pos.y})');
		}

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
