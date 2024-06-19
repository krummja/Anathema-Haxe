package common.struct;


/**
* Fixed-size array with a standard Array API.
* It is optimized to have no memory allocations while supporting common array operations.
*
* Adapted from https://github.com/deepnight/deepnightLibs
*/
class FixedArray<T>
{
    /**
    * Created a FixedArray using the content of a standard Array.
    */
    public static function fromArray<T>(array: Array<T>): FixedArray<T>
    {
        var fixedArray = new FixedArray(0);
        fixedArray.loadArray(array);
        return fixedArray;
    }

    public var name: Null<String>;
    public var preserveOrder: Bool = false;

    /** Count of allocated values **/
    public var allocated(get, never): Int;

    /** Maximum number of values **/
    public var maxSize(get, never): Int;

    @:allow(common.struct.FixedArrayIterator)
    private var values: haxe.ds.Vector<T>;
    private var nalloc: Int;
    private var autoExpandSize: Int = 0;

    public function new(?name: String, maxSize: Int)
    {
        this.name = name;
        this.values = new haxe.ds.Vector(maxSize);
        this.nalloc = 0;
    }

    public inline function iterator(): FixedArrayIterator<T>
    {
        return new FixedArrayIterator<T>(this);
    }

    @:keep
    public function toString(): String
    {
        var a = [];
        for (v in this) a.push(v);
        return a.map((v) -> this.toStringValue(v)).toString() + '<$allocated/$maxSize>';
    }

    /**
    * Return a standard Array using a mapping function on all elements.
    */
    public function toArray<X>(mapValue: T -> X): Array<X>
    {
        var out = [];
        for (value in this) out.push(mapValue(value));
        return out;
    }

    public dynamic function toStringValue(value: T): String
    {
        return Std.string(value);
    }

    /**
    * Check if there's a value at a given index.
    */
    public inline function exists(idx: Int): Bool
    {
        return idx >= 0 && idx < this.nalloc;
    }

    /**
    * Get value at given index, or null if out of bounds.
    */
    public inline function get(idx: Int): Null<T>
    {
        return this.exists(idx) ? this.values[idx] : null;
    }

    public function pickRandom(?rndFunc: Int -> Int, removeAfterPick: Bool = false): Null<T>
    {
        if (this.allocated == 0) return null;

        var idx = (rndFunc == null ? Std.random : rndFunc)(this.allocated);
        var elem = this.get(idx);

        if (removeAfterPick) this.removeIndex(idx);
        return elem;
    }

    /**
    * Set the value at given the index. Throws an error if the index is out of bounds.
    */
    public inline function set(idx: Int, value: T): T
    {
        if (idx < 0 || idx >= this.nalloc)
        {
            throw 'Out-of-bounds FixedArray set (idx=$idx, allocated=$allocated)';
        }

        return this.values[idx] = value;
    }

    /**
    * Get the first value (without modifying the array).
    */
    public inline function first(): Null<T>
    {
        return this.values[0];
    }

    /**
    * Get a random element from the array.
    */
    public inline function oneRandomly(): Null<T>
    {
        return this.allocated > 0 ? this.values[Std.random(this.allocated)] : null;
    }

    /**
    * Get the last value (without modifying the array).
    */
    public inline function last(): Null<T>
    {
        return this.values[this.nalloc - 1];
    }

    /**
    * Remove the last value and return it.
    */
    public inline function pop(): Null<T>
    {
        return this.nalloc > 0 ? this.values[(this.nalloc--) - 1] : null;
    }

    /**
    * Remove the first value and return it.
    *
    * This will affect array order if `preserveOrder` is FALSE (default).
    */
    public function shift(): Null<T>
    {
        if (this.nalloc == 0) return null;

        var value = this.values[0];
        this.removeIndex(0);
        return value;
    }

    /**
    * Clear array content.
    */
    public function empty(): Void
    {
        this.nalloc = 0;
    }

    /**
    * Return TRUE if the array contains the given value.
    */
    public function contains(search: T): Bool
    {
        for (v in this)
        {
            if (v == search) return true;
        }

        return false;
    }

    public function push(elem: T): Void
    {
        if (this.nalloc >= this.values.length)
        {
            throw 'FixedArray limit reached ($maxSize)';
        }

        this.values[this.nalloc] = elem;
        this.nalloc++;
    }

    /**
    * Search and remove given value. Return TRUE if the value was found and removed.
    */
    public function remove(elem: T): Bool
    {
        var found = false;

        for (i in 0...this.nalloc)
        {
            if (this.values[i] == elem)
            {
                this.removeIndex(i);
                found = true;
                break;
            }
        }

        return found;
    }

    /**
    * Remove value a given array index.
    * This will affect the array order if `preserveOrder` is FALSE (default).
    */
    public function removeIndex(idx: Int): Void
    {
        if (idx < this.nalloc)
        {
            if (this.nalloc == 1)
            {
                this.nalloc = 0;
            }

            else if (!this.preserveOrder)
            {
                this.values[idx] = this.values[this.nalloc - 1];
                this.nalloc--;
            }

            else
            {
                for (j in idx + 1...this.nalloc)
                {
                    this.values[j - 1] = values[j];
                }

                this.nalloc--;
            }
        }
    }

    /**
    * Destroy the array.
    */
    public function dispose(): Void
    {
        this.values = null;
        this.nalloc = 0;
    }

    /**
    * Sort the array in place.
    */
    public function bubbleSort(getSortWeight: T -> Float): Void
    {
        var tmp: T;

        for (i in 0...(this.allocated - 1))
        {
            for (j in (i + 1)...this.allocated)
            {
                if (getSortWeight(this.get(i)) > getSortWeight(this.get(j)))
                {
                    tmp = this.get(i);
                    this.set(i, this.get(j));
                    this.set(j, tmp);
                }
            }
        }
    }

    /**
    * Shuffle the array in place.
    */
    public function shuffle(?randFunc: Int -> Int): Void
    {
        if (randFunc == null) randFunc = Std.random;

        var m = this.allocated;
        var i = 0;
        var tmp: T;

        while (m > 0)
        {
            i = randFunc(m--);
            tmp = this.values[m];
            this.values[m] = this.values[i];
            this.values[i] = tmp;
        }
    }

    private function loadArray(array: Array<T>): Void
    {
        this.values = new haxe.ds.Vector(array.length);
        this.nalloc = 0;
        for (e in array) this.push(e);
    }

    private inline function get_allocated(): Int
    {
        return this.nalloc;
    }

    private inline function get_maxSize(): Int
    {
        return this.values.length;
    }
}

private class FixedArrayIterator<T>
{
    private var arr: FixedArray<T>;
    private var i: Int;

    public inline function new(arr: FixedArray<T>)
    {
        this.arr = arr;
        this.i = 0;
    }

    public inline function hasNext(): Bool
    {
        return this.i < this.arr.allocated;
    }

    public inline function next(): T
    {
        return this.arr.values[i++];
    }
}
