package domain.systems;


import core.ecs.Entity;
import domain.components.Sprite;
import common.struct.Coordinate;
import domain.components.Move;
import domain.components.IsActive;
import domain.System;
import core.Frame;
import core.ecs.Query;
import domain.components.Position;


class MovementSystem extends System
{
    private var movers: Query;
    private var entities: Query;

    public function new()
    {
        this.movers = new Query({
            all: [Move],
        });

        this.entities = new Query({
            all: [Position, IsActive],
        });
    }

    public override function update(frame: Frame): Void
    {
        for (entity in this.movers)
        {
            var start = entity.get(Position);
            var move = entity.get(Move);
            var delta = this.getDelta(start.coordinate, move.goal, move.speed, move.tween, frame.tmod);

            if (entity.has(Sprite)) entity.get(Sprite).background = null;

            var deltaSq = delta.lengthSq();
            var distanceSq = start.coordinate.distance(move.goal, WORLD, EUCLIDEAN_SQ);

            start.coordinate.lerp(move.goal, frame.tmod * move.speed);

            if (distanceSq < Math.max(deltaSq, move.epsilon * move.epsilon))
            {
                entity.get(Position).setPosition(move.goal.x, move.goal.y);
                entity.remove(Move);
            }

            else
            {
                var newPos = start.coordinate.add(delta);
                entity.get(Position).setPosition(newPos.x, newPos.y);
            }
        }
    }

    public function finishMoveFast(entity: Entity): Bool
    {
        var move = entity.get(Move);
        if (move != null)
        {
            entity.remove(Move);
            entity.get(Position).setPosition(move.goal.x, move.goal.y);
            return true;
        }

        return false;
    }

    private inline function getDelta(pos: Coordinate, goal: Coordinate, speed: Float, tween: Tween, tmod: Float): Coordinate
    {
        switch tween
        {
            case LINEAR:
                var direction = pos.direction(goal);
                var dx = direction.x * tmod * speed;
                var dy = direction.y * tmod * speed;
                return new Coordinate(dx, dy, WORLD);
            case LERP:
                return pos.lerp(goal, tmod * speed).sub(pos);
            case INSTANT:
                return goal.sub(pos);
        }
    }
}
