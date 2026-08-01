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
			var popped = this.scenes.pop();
			popped.onClosedListener();
			destroy(popped);
		}

		MainLoop.getInstance().input.flush();

		scene.ui = new UIRoot(scene);
		this.scenes.push(scene);
		enter(scene);
	}

	public function replace(scene: Scene) {
		var popped = this.scenes.pop();
		popped.onClosedListener();
		destroy(popped);

		MainLoop.getInstance().input.flush();

		scene.ui = new UIRoot(scene);
		this.scenes.push(scene);
		enter(scene);
	}

	public function push(scene: Scene) {
		current.onSuspend();
		current.ui.onSceneSuspend();
		MainLoop.getInstance().input.flush();

		scene.ui = new UIRoot(scene);
		this.scenes.push(scene);
		enter(current);
	}

	public function pop() {
		var popped = this.scenes.pop();
		popped.onClosedListener();
		destroy(popped);

		MainLoop.getInstance().input.flush();

		current.ui.onSceneResume();
		current.onResume();
	}

	public function onResize(): Void {
		current.ui.onResize();
	}

	private function enter(scene: Scene) {
		scene.onEnter();
		if (scene.ui != null) {
			scene.ui.onSceneEnter();
		}
	}

	private function destroy(scene: Scene) {
		if (scene.ui != null) {
			scene.ui.onSceneDestroy();
		}
		scene.onDestroy();
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
