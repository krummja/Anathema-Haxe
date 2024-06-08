package core.ecs;

import bits.Bits;


class Entity
{
    public var isDetachable: Bool;

    public var engine(get, null): Engine;
    public var registry(get, null): Registry;
    public var flags(default, null): Bits;
    public var id(default, null): String;
    public var isDestroyed(default, null): Bool;
    public var isDetached(default, null): Bool;

    private var components: Map<String, Array<Component>>;
    private var isCandidacyEnabled: Bool = true;

    public function new(register: Bool = true)
    {
        this.flags = new Bits(64);
        this.components = new Map();

        this.isDestroyed = false;
        this.isDetached = false;
        this.isDetachable = false;

        if (register) this.setId(UniqueId.Create());
    }

    public function setId(value: String): Void
    {
        this.id = value;
        this.registry.registerEntity(this);
    }

    public function destroy(): Void
    {
        this.isCandidacyEnabled = false;

        for (component in this.components.copy())
        {
            for (c in component.copy())
            {
                this.remove(c);
            }
        }

        this.isCandidacyEnabled = true;
        this.isDestroyed = true;

        this.registry.unregisterEntity(this);
    }

    public function fireEvent<T: EntityEvent>(event: T): T
    {
        this.components.each((a) -> {
            a.each((c) -> {
                c.onEvent(event);
            });
        });

        return event;
    }

    public function add(component: Component): Void
    {
        var type = Type.getClass(component);
        var cList = this.components.get(component.type);

        if (cList == null)
        {
            this.components.set(component.type, [component]);
        }

        else if (component.instanceAllowMultiple)
        {
            this.components.get(component.type).push(component);
        }

        else
        {
            if (this.has(type)) this.remove(type);
            this.components.set(component.type, [component]);
        }

        this.flags.set(component.bit);
        component.attach(this);

        if (this.isCandidacyEnabled) this.registry.candidacy(this);
    }

    public overload extern inline function remove(component: Component): Void
    {
        this.removeInstance(component);
    }

    public overload extern inline function remove<T: Component>(type: Class<T>): Void
    {
        if (Reflect.field(type, "allowMultiple"))
        {
            var cs = getAll(type);
            cs.each(removeInstance);
        }

        else
        {
            var c = get(type);
            if (c != null) this.removeInstance(c);
        }
    }

    public inline function has<T: Component>(type: Class<Component>): Bool
    {
        return this.flags.isSet(this.registry.getBit(type));
    }

    public function getAll<T: Component>(type: Class<T>): Array<T>
    {
        var cs = this.components.get(Type.getClassName(type));
        return cs == null ? [] : cast cs;
    }

    public function get<T: Component>(type: Class<T>): T
    {
        var component = this.components.get(Type.getClassName(type));
        if (component == null) return null;
        return cast component[0];
    }

    public function detach(): Void
    {
        this.isDetached = true;
        this.registry.detachEntity(this.id);
    }

    public function reattach(): Void
    {
        this.registry.reattachEntity(this.id);
        this.isDetached = false;
    }

    private function removeInstance(component: Component): Void
    {
        if (component.instanceAllowMultiple)
        {
            var cList = this.components.get(component.type);
            if (cList != null)
            {
                cList.remove(component);
                if (cList.length == 0)
                {
                    this.flags.unset(component.bit);
                    this.components.remove(component.type);
                }
            }
        }

        else
        {
            this.flags.unset(component.bit);
            this.components.remove(component.type);
        }

        component.remove();

        if (this.isCandidacyEnabled) this.registry.candidacy(this);
    }

    private inline function get_engine(): Engine
    {
        return Engine.instance;
    }

    private inline function get_registry(): Registry
    {
        return Engine.instance.registry;
    }
}
