package domain.systems;

import domain.components.IsPlayer;
import core.ecs.EntityEvent;
import data.EnergyActionType;
import core.Frame;
import core.ecs.Entity;
import domain.components.Energy;
import core.ecs.Query;


class EnergySystem extends System
{
    public static function ConsumeEnergy(entity: Entity, type: EnergyActionType): Void
    {
        var cost = getEnergyCost(entity, type);
        entity.fireEvent("consumeEnergy", { cost: cost });
    }

    public static function getEnergyCost(entity: Entity, type: EnergyActionType): Int
    {
        return switch type
        {
            case ACT_MOVE:
                return 80;
            case ACT_WAIT:
                return 500;
            case _:
                return 50;
        }
    }

    public var isPlayerTurn(default, null): Bool;

    private var query: Query;

    public function new()
    {
        this.isPlayerTurn = false;

        this.query = new Query({
            all: [Energy],
        });
    }

    public override function update(frame: Frame): Void
    {
        this.world.clock.clearDeltas();

        while (true)
        {
            var entity = this.getNext();

            if (!entity.isNull() && entity.has(IsPlayer))
            {
                this.isPlayerTurn = true;
                break;
            }

            this.isPlayerTurn = false;
        }
    }

    private function getNext(): Entity
    {
        var entity = this.query.max((e) -> e.get(Energy).value);
        if (entity.isNull()) return null;

        var energy = entity.get(Energy);

        if (!energy.hasEnergy)
        {
            var tickAmount = -energy.value;
            this.world.clock.incrementTick(tickAmount);
            this.query.each((e) -> e.get(Energy).addEnergy(tickAmount));
        }

        return entity;
    }
}
