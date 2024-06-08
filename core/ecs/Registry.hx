package core.ecs;

import common.struct.Set;


class Registry
{
    private var cbit: Int;
    private var bits: Map<String, Int>;
    private var queries: Array<Query>;
    private var entityMap: Map<String, Entity>;
    private var detached: Set<String>;

    public var size(default, null): Int;

    public function new()
    {
        this.cbit = 0;
        this.size = 0;
        this.bits = new Map();
        this.entityMap = new Map();
        this.detached = new Set();
        this.queries = new Array();
    }

    public function iterator(): Iterator<Entity>
    {
        return this.entityMap.iterator();
    }

    public function register<T: Component>(type: Class<Component>): Int
    {
        var className = Type.getClassName(type);
        if (this.bits.exists(className)) return this.bits.get(className);
        this.bits.set(className, ++cbit);
        return this.cbit;
    }

    public function getEntity(entityId: String): Entity
    {
        return this.entityMap.get(entityId);
    }

    public function getBit<T: Component>(type: Class<Component>): Int
    {
        var className = Type.getClassName(type);
        var bit = this.bits.get(className);

        if (bit == null) return this.register(type);
        return bit;
    }

    public function candidacy(entity: Entity): Void
    {
        for (query in this.queries) query.candidate(entity);
    }

    public function detachedIterator(): Iterator<String>
    {
        return this.detached.iterator();
    }

    @:allow(core.ecs.Query)
    private function registerQuery(query: Query): Void
    {
        this.queries.push(query);
    }

    @:allow(core.ecs.Query)
    private function unregisterQuery(query: Query): Void
    {
        this.queries.remove(query);
    }

    @:allow(core.ecs.Entity)
    private function registerEntity(entity: Entity): Void
    {
        if (this.entityMap.exists(entity.id))
        {
            trace('Given entity id (${entity.id}) is already registered');
            return;
        }

        this.size++;
        this.entityMap.set(entity.id, entity);
    }

    @:allow(core.ecs.Entity)
    private function unregisterEntity(entity: Entity): Void
    {
        this.candidacy(entity);
        this.size--;
        this.entityMap.remove(entity.id);
        this.detached.remove(entity.id);
    }

    @:allow(core.ecs.Entity)
    private function detachEntity(entityId: String): Void
    {
        this.detached.add(entityId);
    }

    @:allow(core.ecs.Entity)
    private function reattachEntity(entityId: String): Void
    {
        this.detached.remove(entityId);
    }
}
