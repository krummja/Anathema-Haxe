package engine;

import engine.Scene.EmptyScene;

class SceneManager {
	public var loop(default, null): MainLoop;
	public var current(get, null): Scene;
	public var previous(get, null): Scene;
	public var domain(get, null): InputDomainType;
	public var stack(get, null): Array<Scene>;

	private var scenes: Array<Scene>;

	public function new(loop: MainLoop) {
		this.loop = loop;
		this.scenes = new Array();
		this.scenes.push(new EmptyScene());
	}

	public function update(frame: Frame): Void {
		this.current.handleInput();
		this.current.update(frame);
	}

	public function set(scene: Scene) {
		while (this.scenes.length > 0) {
			current.onDestroy();
			this.scenes.pop().onClosedListener();
		}

		MainLoop.getInstance().input.flush();
		this.scenes.push(scene);
		current.onEnter();
	}

	public function replace(scene: Scene) {
		current.onDestroy();
		this.scenes.pop().onClosedListener();
		MainLoop.getInstance().input.flush();
		this.scenes.push(scene);
		current.onEnter();
	}

	public function push(scene: Scene) {
		current.onSuspend();
		MainLoop.getInstance().input.flush();
		this.scenes.push(scene);
		current.onEnter();
	}

	public function pop() {
		current.onDestroy();
		this.scenes.pop().onClosedListener();
		MainLoop.getInstance().input.flush();
		current.onResume();
	}

	private function get_current(): Scene {
		return this.scenes[this.scenes.length - 1];
	}

	private function get_previous(): Scene {
		return this.scenes[this.scenes.length - 2];
	}

	private function get_domain(): InputDomainType {
		return current.inputDomain;
	}

	private function get_stack(): Array<Scene> {
		return this.scenes.copy();
	}
}
