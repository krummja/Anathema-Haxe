package domain.prefabs;

import core.ecs.EntityEvent;
import common.struct.Coordinate;
import core.MainLoop;
import core.ecs.Entity;

import data.SpawnableType;


class Spawner
{
    public static function Spawn(type: SpawnableType, ?pos: Coordinate, ?options: Dynamic)
    {
        return MainLoop.instance.world.spawner.spawn(type, pos, options);
    }

    @:allow(Main)
    private var prefabs: Map<SpawnableType, Prefab>;

    public function new()
    {
        this.prefabs = new Map();
    }

    public function initialize()
    {
        this.prefabs.set(PLAYER, new TestPrefab());
        this.prefabs.set(FLOOR, new FloorPrefab());
    }

    public function spawn(type: SpawnableType, ?pos: Coordinate, ?options: Dynamic): Entity
    {
        var p = pos == null ? new Coordinate(0, 0, WORLD) : pos.toWorld().floor();
        var o = options == null ? {} : options;
        var entityType = this.prefabs.get(type);
        var entity = entityType.Create(o, p);

        entity.fireEvent(new EntityEvent("entitySpawned"));
        return entity;
    }
}
