package domain.components;

import core.ecs.EntityEvent;
import core.ecs.Component;


class Energy extends Component
{
    public var value(default, null): Int = 5;

    public var hasEnergy(get, never): Bool;

    public function new(value: Int = 0)
    {
        this.value = value;
    }

    public function addEnergy(value: Int): Void
    {
        this.value += value;
        if (this.value > 0) this.value = 0;
    }

    public function consumeEnergy(value: Int): Void
    {
        this.addEnergy(-1 * value);
    }

    private function on_consumeEnergy(event: EntityEvent): EntityEvent
    {
        this.consumeEnergy(event.data["value"]);
        return event;
    }

    private function get_hasEnergy(): Bool
    {
        return this.value >= 0;
    }
}
