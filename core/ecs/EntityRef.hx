package core.ecs;


class EntityRef
{
    private var entityId: String;

    public var entity(get, set): Null<Entity>;

    public function new(id: String = "")
    {
        this.entityId = id;
    }

    private inline function get_entity(): Null<Entity>
    {
        return MainLoop.instance.ecs.registry.getEntity(this.entityId);
    }

    private inline function set_entity(value: Entity): Null<Entity>
    {
        this.entityId = value == null ? "" : value.id;
        return value;
    }
}
