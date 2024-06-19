package scenes;

import common.struct.Coordinate;
import core.Command;
import core.Frame;
import core.KeyCode;
import core.Scene;
import data.Cardinal;
import domain.components.Move;


class TestScene extends Scene
{
    public function new() {}

    private override function onEnter(): Void
    {
        for (x in 0...100) {
            for (y in 0...100) {
                this.loop.world.spawner.spawn(FLOOR, new Coordinate(x * 16, y * 16, WORLD));
            }
        }
    }

    private override function onDestroy(): Void {}

    private override function onKeyDown(key: KeyCode): Void {}

    private override function onMouseMove(pos: Coordinate, prev: Coordinate): Void {}

    private override function update(frame: Frame): Void
    {
        if (this.world.systems.energy.isPlayerTurn)
        {
            var cmd = this.loop.commands.peek();
            if (cmd != null)
            {
                if (this.world.player.entity.has(Move))
                {
                    this.world.systems.movement.finishMoveFast(world.player.entity);
                }

                else
                {
                    this.handle(cmd);
                }
            }
        }
    }

    private function handle(command: Command): Void
    {
        switch (command.type)
        {
            case CMD_MOVE_N:
                this.move(NORTH);
            case CMD_MOVE_NE:
                this.move(NORTH_EAST);
            case CMD_MOVE_E:
                this.move(EAST);
            case CMD_MOVE_SE:
                this.move(SOUTH_EAST);
            case CMD_MOVE_S:
                this.move(SOUTH);
            case CMD_MOVE_SW:
                this.move(SOUTH_WEST);
            case CMD_MOVE_W:
                this.move(WEST);
            case CMD_MOVE_NW:
                this.move(NORTH_WEST);
            case CMD_WAIT:
            case _:
        }
    }

    private function move(direction: Cardinal): Void
    {
        var target = this.world.player.pos.toIntPoint().add(direction.toOffset());
        this.world.player.entity.add(new Move(target.asWorld(), 0.15, LINEAR));
    }
}
