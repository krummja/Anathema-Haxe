package domain.prefabs;

import domain.components.IsOpaque;
import domain.components.IsSolid;
import domain.components.Position;
import domain.components.Sprite;
import common.struct.Coordinate;
import core.ecs.Entity;


class FloorPrefab extends Prefab
{
    public function Create(options: Dynamic, pos: Coordinate): Entity
    {
        var entity = new Entity();

        entity.add(new Sprite(TK_GRASS_1, C_GREEN_3, C_GREEN_5, GROUND));
        entity.add(new Position(pos.x, pos.y));
        entity.add(new IsSolid());
        entity.add(new IsOpaque());

        return entity;
    }
}
