package domain.prefabs;

import domain.components.Energy;
import domain.components.IsPlayer;
import domain.components.IsActive;
import domain.components.Position;
import domain.components.Sprite;
import core.ecs.Entity;
import common.struct.Coordinate;


class TestPrefab extends Prefab
{
    public function Create(options: Dynamic, pos: Coordinate): Entity
    {
        var entity = new Entity();

        entity.add(new Sprite(TK_LIL_GUY_1, C_YELLOW_0, C_BLUE_4, ACTOR));
        entity.add(new Position(pos.x, pos.y));
        entity.add(new Energy());
        entity.add(new IsPlayer());

        return entity;
    }
}
