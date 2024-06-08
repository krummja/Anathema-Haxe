package domain.systems;


import domain.System;
import core.Frame;
import core.ecs.Query;
import domain.components.Position;


class MovementSystem extends System
{
    private var entities: Query;

    public function new()
    {
        this.entities = new Query({
            all: [Position],
        });
    }

    public override function update(frame: Frame): Void
    {
        for (entity in this.entities) {
            var pos = entity.get(Position);
            pos.move(1.0, 1.0);
        }
    }
}
