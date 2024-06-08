package scenes;

import core.Frame;
import common.struct.Coordinate;
import core.KeyCode;
import core.Scene;


class TestScene extends Scene
{
    public function new() {}

    private override function onEnter(): Void
    {
        trace("Entered TestScene");
        trace(this.loop);
    }

    private override function onDestroy(): Void {}

    private override function onKeyDown(key: KeyCode): Void
    {
        switch (key)
        {
            case KEY_W:
            case KEY_A:
            case KEY_S:
            case KEY_D:
            case _:
        }
    }

    private override function onMouseMove(pos: Coordinate, prev: Coordinate): Void
    {
        trace(pos.toString());
    }

    private override function update(frame: Frame): Void
    {
    }
}
