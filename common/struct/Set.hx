package common.struct;

using haxe.iterators.ArrayIterator;
using common.extensions.IterableExtensions;


@:generic
class Set<T>
{
    public var items: Array<T>;
    public var isEmpty(get, never): Bool;
    public var length(get, never): Int;

    public function new()
    {
        this.items = new Array();
    }

    public function has(value: T): Bool
    {
        return this.items.exists(x -> x == value);
    }

    public function add(value: T): Int
    {
        if (!this.has(value)) this.items.push(value);
        return this.length;
    }

    public function remove(value: T): Bool
    {
        return this.items.remove(value);
    }

    public function pop(): Null<T>
    {
        return this.isEmpty ? null : this.items.pop();
    }

    public function iterator(): ArrayIterator<T>
    {
        return this.items.iterator();
    }

    public function asArray(): Array<T>
    {
        return this.items;
    }

    private function get_isEmpty(): Bool
    {
        return this.items.length == 0;
    }

    private function get_length(): Int
    {
        return this.items.length;
    }
}
