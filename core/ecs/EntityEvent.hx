package core.ecs;


abstract EventData(Dynamic) from Dynamic
{
    public inline function new()
    {
        this = {};
    }

    @:arrayAccess
    public inline function get(key: String): Null<Dynamic>
    {
        #if (js || python)
            return untyped this[key];
        #else
            return Reflect.field(this, key);
        #end
    }

    @:arrayAccess
    public inline function set(key: String, value: Dynamic): Void
    {
        Reflect.setField(this, key, value);
    }

    public inline function exists(key: String): Bool
    {
        return Reflect.hasField(this, key);
    }

    public inline function remove(key: String): Bool
    {
        return Reflect.deleteField(this, key);
    }

    public inline function keys(): Array<String>
    {
        return Reflect.fields(this);
    }
}


class EntityEvent
{
    public var name(default, null): String;
    public var data(default, null): EventData;

    public function new(name: String, ?eventData: EventData)
    {
        this.name = name;
        this.data = eventData;
    }
}
