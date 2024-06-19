package domain;

import domain.terrain.ZoneManager;
import domain.terrain.ChunkManager;
import common.struct.IntPoint;
import common.struct.Coordinate;
import domain.prefabs.Spawner;
import domain.components.Position;
import core.ecs.Entity;
import core.MainLoop;


class World
{
    public var loop(get, null): MainLoop;
    public var systems(default, null): SystemManager;
    public var player(default, null): PlayerManager;
    public var spawner(default, null): Spawner;
    public var chunks(default, null): ChunkManager;
    public var zones(default, null): ZoneManager;
    public var clock(default, null): Clock;

    public var zoneCountX(default, null): Int = 64;
    public var zoneCountY(default, null): Int = 48;
    public var zoneSize(default, null): Int = 64;

    public var chunksPerZone(default, never): Int = 4;
    public var chunkSize(get, never): Int;
    public var chunkCountX(get, never): Int;
    public var chunkCountY(get, never): Int;

    public var worldWidth(get, null): Int;
    public var worldHeight(get, null): Int;

    public function new()
    {
        this.systems = new SystemManager();
        this.spawner = new Spawner();
        this.player = new PlayerManager();
        this.chunks = new ChunkManager();
        this.zones = new ZoneManager();
        this.clock = new Clock();
    }

    public function initialize(): Void
    {
        this.spawner.initialize();
        this.systems.initialize();
    }

    public function start(): Void
    {
        // var pos = new Coordinate(
        //     (this.worldWidth / 2).floor(),
        //     (this.worldHeight / 2).floor(),
        //     WORLD,
        // );

        var pos = new Coordinate(128, 128, WORLD);
        this.player.create(pos);
    }

    public function update(): Void
    {
        this.systems.update(this.loop.frame);
    }

    public overload extern inline function getEntitiesAt(pos: IntPoint): Array<Entity>
    {
        var w = pos.asWorld();
        var idx = pos.asWorld().toChunkId();
        var chunk = this.chunks.getChunkById(idx);

        if (chunk.isNull()) return new Array<Entity>();

        var local = w.toChunkLocal();
        var ids = chunk.getEntityIdsAt(local.x, local.y);
        return ids.map((id: String) -> this.loop.ecs.registry.getEntity(id));
    }

    private function get_loop(): MainLoop
    {
        return MainLoop.instance;
    }

    private function get_worldWidth(): Int
    {
        return this.chunkCountX * this.chunkSize;
    }

    private function get_worldHeight(): Int
    {
        return this.chunkCountY * this.chunkSize;
    }

    private function get_chunkCountX(): Int
    {
        return this.zoneCountX * this.chunksPerZone;
    }

    private function get_chunkCountY(): Int
    {
        return this.zoneCountY * this.chunksPerZone;
    }

    private function get_chunkSize(): Int
    {
        return (this.zoneSize / this.chunksPerZone).ceil();
    }
}
