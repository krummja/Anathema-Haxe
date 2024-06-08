package core;

import domain.World;
import common.struct.Coordinate;


abstract class Scene
{
    public var loop(get, null): core.MainLoop;
    public var camera(get, null): Camera;
    public var world(get, null): World;

    public var inputDomain: InputDomainType = INPUT_DOMAIN_DEFAULT;

    public var onClosedListener: () -> Void = () -> {};

    @:allow(core.MainLoop)
    private function update(frame: Frame): Void {}

    @:allow(core.SceneManager)
    private function onEnter(): Void {}

    @:allow(core.SceneManager)
    private function onDestroy(): Void {}

    @:allow(core.SceneManager)
    private function onSuspend(): Void {}

    @:allow(core.SceneManager)
    private function onResume(): Void {}

    @:allow(core.InputManager)
    private function onMouseDown(pos: Coordinate): Void {}

    @:allow(core.InputManager)
    private function onMouseUp(pos: Coordinate): Void {}

    @:allow(core.InputManager)
    private function onMouseMove(pos: Coordinate, prev: Coordinate): Void {}

    @:allow(core.InputManager)
    private function onKeyDown(key: KeyCode): Void {}

    private function get_loop(): MainLoop
    {
        return MainLoop.instance;
    }

    private function get_world(): World
    {
        return MainLoop.instance.world;
    }

    private function get_camera(): Camera
    {
        return MainLoop.instance.camera;
    }
}


class EmptyScene extends Scene
{
    public function new() {}
}
