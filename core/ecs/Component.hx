package core.ecs;


class Component
{
    public static var allowMultiple(default, null): Bool;

    public var bit(get, null): Int = 0;
    public var type(get, null): String;
    public var isAttached(get, null): Bool;
    public var entity(default, null): Entity;
    public var instanceAllowMultiple(get, null): Bool;

    private var handlers: Map<String, (event: EntityEvent) -> Void> = new Map();

    private function onRemove(): Void {}

    @:allow(core.ecs.Entity)
    private function onEvent(event: EntityEvent): Void
    {
        var className = Type.getClassName(Type.getClass(event));
        var handler = this.handlers.get(className);
        if (handler != null && this.isAttached) handler(event);
    }

    @:allow(core.ecs.Entity)
    private function attach(entity: Entity): Void
    {
        this.entity = entity;
    }

    @:allow(core.ecs.Entity)
    private function remove(): Void
    {
        this.onRemove();
        this.entity = null;
    }

    private function get_bit(): Int
    {
        if (this.bit > 0) return this.bit;
        this.bit = Engine.instance.registry.register(Type.getClass(this));
        return this.bit;
    }

    private function get_type(): String
    {
        return Type.getClassName(Type.getClass(this));
    }

    private function get_isAttached(): Bool
    {
        return this.entity != null;
    }

    private function get_instanceAllowMultiple(): Bool
    {
        return Reflect.field(Type.getClass(this), "allowMultiple");
    }
}


typedef ComponentFields = {
    f: String,
    v: Dynamic,
}
