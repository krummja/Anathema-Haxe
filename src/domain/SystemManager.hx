package domain;

import domain.systems.Energy.EnergySystem;
import core.Frame;
import domain.systems.Movement.MovementSystem;
import domain.systems.Sprite.SpriteSystem;


class SystemManager
{
    public var movement(default, null): MovementSystem;
    public var sprite(default, null): SpriteSystem;
    public var energy(default, null): EnergySystem;

    public function new() {}

    public function initialize(): Void
    {
        this.movement = new MovementSystem();
        this.sprite = new SpriteSystem();
        this.energy = new EnergySystem();
    }

    public function update(frame: Frame): Void
    {
        this.movement.update(frame);
        this.sprite.update(frame);
        this.energy.update(frame);
    }
}
