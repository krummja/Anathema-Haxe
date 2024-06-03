package core;


abstract class Scene
{
    public var loop(get, null): core.MainLoop;

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
}


class EmptyScene extends Scene
{
    public function new() {}
}
