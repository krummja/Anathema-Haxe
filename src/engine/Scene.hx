package engine;

import common.struct.Coordinate;
import domain.PlayerManager;
import domain.World;
import emitter.Emitter;

abstract class Scene {
	public var emitter: Emitter;

	public var loop(get, null): MainLoop;
	public var camera(get, null): Camera;
	public var world(get, null): World;
	public var player(get, null): PlayerManager;

	@:allow(engine.SceneManager)
	private var ui: UIRoot;

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

	@:allow(engine.InputManager)
	private function onMouseDown(pos: Coordinate): Void {}

	@:allow(engine.InputManager)
	private function onMouseUp(pos: Coordinate): Void {}

	@:allow(engine.InputManager)
	private function onMouseMove(pos: Coordinate, prev: Coordinate): Void {}

	@:allow(engine.InputManager)
	private function onKeyDown(key: KeyCode): Void {}

	@:allow(engine.InputManager)
	private function onMouseWheel(delta: Float): Void {}

	@:allow(engine.InputManager)
	private function onKeyUp(key: KeyCode): Void {}

	@:allow(engine.SceneManager)
	private function handleInput(): Void {}

	private function get_player(): PlayerManager {
		return MainLoop.getInstance().world.player;
	}

	private function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}

	private function get_world(): World {
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
