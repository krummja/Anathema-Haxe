package domain;

import domain.systems.Movement.MovementSystem;
import core.Frame;


class SystemManager
{
    public var movement(default, null): MovementSystem;

    public function new() {}

    public function initialize(): Void
    {
        this.movement = new MovementSystem();
    }

    public function update(frame: Frame): Void
    {
        this.movement.update(frame);
    }
}
