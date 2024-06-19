package domain.terrain;

import common.struct.GridMap;


class Chunk
{
    public var entities(default, null): GridMap<String>;

    public function new(chunkId: Int, size: Int)
    {

    }

    public function getEntityIdsAt(x: Float, y: Float): Array<String>
    {
        return this.entities.get(x.floor(), y.floor());
    }
}
