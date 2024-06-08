package core.ecs;

import bits.Bits;


typedef QueryFilter = {
    var ?all: Array<Class<Component>>;
    var ?any: Array<Class<Component>>;
    var ?none: Array<Class<Component>>;
}


class Query
{
    private var any: Bits;
    private var all: Bits;
    private var none: Bits;
    private var isDisposed: Bool;
    private var cache: Map<String, Entity>;

    private var onAddListeners: Array<(Entity) -> Void>;
    private var onRemoveListeners: Array<(Entity) -> Void>;

    public var registry(get, null): Registry;
    public var size(default, null): Int;

    public function new(filter: QueryFilter)
    {
        this.isDisposed = false;
        this.onAddListeners = new Array();
        this.onRemoveListeners = new Array();
        this.cache = new Map();
        this.size = 0;

        this.any = this.getBitmask(filter.any);
        this.all = this.getBitmask(filter.all);
        this.none = this.getBitmask(filter.none);

        this.registry.registerQuery(this);
        this.refresh();
    }

    public inline function iterator(): QueryIterator
    {
        return new QueryIterator(this.cache);
    }

    public function setFilter(filter: QueryFilter): Void
    {
        this.any = this.getBitmask(filter.any);
        this.all = this.getBitmask(filter.all);
        this.none = this.getBitmask(filter.none);
        this.refresh();
    }

    public function matches(entity: Entity): Bool
    {
        var flags = entity.flags;
        var matchesAny = this.any.count() == 0 || flags.intersect(this.any).count() > 0;
        var matchesAll = flags.intersect(this.all).count() == this.all.count();
        var matchesNone = flags.intersect(this.none).count() == 0;
        return matchesAny && matchesAll && matchesNone;
    }

    public function candidate(entity: Entity): Bool
    {
        var isTracking = this.cache.exists(entity.id);

        if (this.matches(entity))
        {
            if (!isTracking)
            {
                this.size++;
                this.cache.set(entity.id, entity);
                this.onAddListeners.each((listener) -> listener(entity));
            }

            return true;
        }

        if (isTracking)
        {
            this.size--;
            this.cache.remove(entity.id);
            this.onRemoveListeners.each((listener) -> listener(entity));
        }

        return false;
    }

    public function refresh(): Void
    {
        this.size = 0;
        this.cache.clear();
        this.registry.each((e) -> this.candidate(e));
    }

    public function onEntityAdded(fn: (Entity) -> Void): Void
    {
        this.onAddListeners.push(fn);
    }

    public function onEntityRemoved(fn: (Entity) -> Void): Void
    {
        this.onRemoveListeners.push(fn);
    }

    public function dispose(): Void
    {
        this.isDisposed = true;
        this.onAddListeners = new Array();
        this.onRemoveListeners = new Array();
        this.cache = new Map();
        this.size = 0;
        this.registry.unregisterQuery(this);
    }

    private function getBitmask(components: Array<Class<Component>>): Bits
    {
        var bits = new Bits();

        if (components == null) return bits;

        components.each((c) -> {
            bits.set(this.registry.getBit(c));
        });

        return bits;
    }

    private function get_registry(): Registry
    {
        return Engine.instance.registry;
    }
}


class QueryIterator
{
    private var entities: Array<Entity> = [];
    private var i: Int = 0;

    public inline function new(cache: Map<String, Entity>)
    {
        cache.each((e) -> this.entities.push(e));
    }

    public inline function hasNext()
    {
        if (this.i >= this.entities.length) return false;

        if (entities[this.i].isDestroyed) {
            this.i++;
            return this.hasNext();
        }

        return true;
    }

    public inline function next(): Entity
    {
        return this.entities[this.i++];
    }
}
