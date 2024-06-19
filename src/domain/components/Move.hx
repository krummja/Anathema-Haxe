package domain.components;

import common.struct.Coordinate;
import core.ecs.Component;


enum Tween
{
    LINEAR;
    LERP;
    INSTANT;
}


class Move extends Component
{
    public var goal: Coordinate;
    public var tween: Tween;
    public var speed: Float;
    public var epsilon: Float;

    public function new(goal: Coordinate, speed: Float = 0.05, tween: Tween = LINEAR, epsilon: Float = 0.0075)
    {
        this.goal = goal;
        this.speed = speed;
        this.tween = tween;
        this.epsilon = epsilon;
    }
}
