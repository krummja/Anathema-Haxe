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

	/**
	 * Completely clear the scene stack and set a new root scene.
	 */
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

	/**
	 * Pop the topmost scene and push a new scene.
	 *
	 * ```
	 *  Scene B       Scene C
	 *  (destroyed)   (active)
	 *  ---------     ---------
	 *           ↖   ↙
	 *         ---------   Scene A (suspended)
	 * ```
	 */
	public function replace(scene: Scene) {
		var popped = this.scenes.pop();
		popped.onClosedListener();
		destroy(popped);

		MainLoop.getInstance().input.flush();

		scene.ui = new UIRoot(scene);
		this.scenes.push(scene);
		enter(scene);
	}

	/**
	 * Push a scene on top of an existing scene.
	 *
	 * ```
	 * 	---------   Scene B (active)
	 * 		↓
	 * 	---------   Scene A (suspended)
	 * ```
	 */
	public function push(scene: Scene) {
		current.onSuspend();
		current.ui.onSceneSuspend();
		MainLoop.getInstance().input.flush();

		scene.ui = new UIRoot(scene);
		this.scenes.push(scene);
		enter(current);
	}

	/**
	 * Pop the topmost scene from the scene stack.
	 *
	 * ```
	 *  ---------   Scene B (destroyed)
	 *      ↑
	 *  ---------   Scene A (active)
	 * ```
	 */
	public function pop() {
		var popped = this.scenes.pop();
		popped.onClosedListener();
		destroy(popped);

		MainLoop.getInstance().input.flush();

		current.ui.onSceneResume();
		current.onResume();
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

	@:allow(engine.MainLoop)
	private function onResize(): Void {
		current.ui.onResize();
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
