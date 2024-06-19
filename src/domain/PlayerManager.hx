package domain;

import core.MainLoop;
import domain.prefabs.Spawner;
import domain.components.Position;
import common.struct.Coordinate;
import core.ecs.Entity;
import core.ecs.EntityRef;


class PlayerManager
{
    private var entityRef: EntityRef;

    public var entity(get, never): Entity;
    public var x(get, set): Float;
    public var y(get, set): Float;
    public var pos(get, set): Coordinate;

    public function new()
    {
        this.entityRef = new EntityRef();
    }

    public function create(pos: Coordinate)
    {
        this.entityRef.entity = MainLoop.instance.world.spawner.spawn(PLAYER, pos);
    }

    private inline function get_entity(): Entity
    {
        return this.entityRef.entity;
    }

    private inline function get_x(): Float
    {
        if (!this.entity.has(Position)) return 0.0;
        return this.entity.get(Position).x;
    }

    private inline function get_y(): Float
    {
        if (!this.entity.has(Position)) return 0.0;
        return this.entity.get(Position).y;
    }

    private inline function get_pos(): Coordinate
    {
        return new Coordinate(this.x, this.y, WORLD);
    }

    private inline function set_x(value: Float): Float
    {
        this.entity.get(Position).setPosition(value, this.y);
        return value;
    }

    private inline function set_y(value: Float): Float
    {
        this.entity.get(Position).setPosition(this.x, value);
        return value;
    }

    private inline function set_pos(value: Coordinate): Coordinate
    {
        this.entity.get(Position).setPosition(value.x, value.y);
        return value;
    }
}
