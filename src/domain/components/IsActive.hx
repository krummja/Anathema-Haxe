package domain.components;

import core.ecs.EntityEvent;
import core.ecs.Component;


class IsActive extends Component
{
    public function new() {}

    public function on_entitySpawned(event: EntityEvent): EntityEvent
    {
        return event;
    }
}
