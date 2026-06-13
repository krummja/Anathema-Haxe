package domain;

import domain.World;
import core.Frame;


class System
{
    public var engine(get, null): core.ecs.Engine;
    // public var world(get, null): World;

    public function update(frame: Frame): Void {}

    private inline function get_engine(): core.ecs.Engine
    {
        return core.ecs.Engine.instance;
    }

    // private inline function get_world(): World {
    //     return engine.world;
    // }
}
