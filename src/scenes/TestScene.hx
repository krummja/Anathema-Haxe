package scenes;

import core.Coordinate;
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
        trace(key);
    }

    private override function onMouseMove(pos: Coordinate, prev: Coordinate): Void
    {
        trace(pos.toString());
    }
}
