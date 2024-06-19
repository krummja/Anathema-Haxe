package domain;

import core.MainLoop;
import core.Frame;


class System
{
    public var engine(get, null): core.ecs.Engine;
    public var domain(get, null): core.ecs.Domain;
    public var world(get, null): World;

    public function update(frame: Frame): Void {}

    private inline function get_engine(): core.ecs.Engine
    {
        return core.ecs.Engine.instance;
    }

    private inline function get_domain(): core.ecs.Domain
    {
        return this.engine.domain;
    }

    private inline function get_world(): World
    {
        return MainLoop.instance.world;
    }
}
