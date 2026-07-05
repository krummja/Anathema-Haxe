package engine;

import emitter.Emitter;
import common.struct.Coordinate;

abstract class Scene {
	public var emitter: Emitter;

	public var loop(get, null): MainLoop;
	public var camera(get, null): Camera;
	public var world(get, null): domain.World;

	public var inputDomain: InputDomainType = INPUT_DOMAIN_DEFAULT;
	public var onClosedListener: () -> Void = () -> {};

	@:allow(engine.SceneManager)
	private function update(frame: Frame): Void {}

	@:allow(engine.SceneManager)
	private function onEnter(): Void {}

	@:allow(engine.SceneManager)
	private function onDestroy(): Void {}

	@:allow(engine.SceneManager)
	private function onSuspend(): Void {}

	@:allow(engine.SceneManager)
	private function onResume(): Void {}

	@:allow(InputManager)
	private function onMouseDown(pos: Coordinate): Void {}

	@:allow(InputManager)
	private function onMouseUp(pos: Coordinate): Void {}

	@:allow(InputManager)
	private function onMouseMove(pos: Coordinate, prev: Coordinate): Void {}

	@:allow(engine.InputManager)
	private function onKeyDown(key: KeyCode): Void {}

	@:allow(engine.InputManager)
	private function onKeyUp(key: KeyCode): Void {}

	@:allow(engine.SceneManager)
	private function handleInput(): Void {
		// var cmd = MainLoop.getInstance().commands.next();
		// if (cmd != null) {
		// 	trace(cmd);
		// }
	}

	private function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}

	private function get_world(): domain.World {
		return MainLoop.getInstance().world;
	}

	private function get_camera(): Camera {
		return MainLoop.getInstance().camera;
	}
}

class EmptyScene extends Scene {
	public function new() {
		this.emitter = new Emitter();
	}
}
