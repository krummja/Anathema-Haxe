package core.ecs;


class Domain
{
    public var engine(get, null): Engine;

    public function new()
    {

    }

    private function get_engine(): Engine
    {
        return Engine.instance;
    }
}
