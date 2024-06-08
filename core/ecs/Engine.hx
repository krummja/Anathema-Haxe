package core.ecs;


interface IEngine
{
    public var domain(default, null): Domain;
    public var registry(default, null): Registry;
}


class Engine implements IEngine
{
    public static var instance: Engine;

    public var domain(default, null): Domain;
    public var registry(default, null): Registry;

    public function new()
    {
        this.domain = new Domain();
        this.registry = new Registry();
        Engine.instance = this;
    }
}
