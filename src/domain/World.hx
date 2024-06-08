package domain;

import domain.components.Position;
import core.ecs.Entity;
import core.MainLoop;


class World
{
    public var loop(get, null): MainLoop;
    public var systems(default, null): SystemManager;

    public function new()
    {
        this.systems = new SystemManager();
    }

    public function initialize(): Void
    {
        var entity = new Entity();
        entity.add(new Position(10.0, 10.0));
        this.systems.initialize();
    }

    public function update(): Void
    {
        this.systems.update(this.loop.frame);
    }

    private function get_loop(): MainLoop
    {
        return MainLoop.instance;
    }
}
