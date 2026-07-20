package engine;

import haxe.ui.containers.Box;

@:xml('
<box styleName="ui-root" width="100%" height="100%">
    // Additional components are mounted via `addComponent`.
</box>
')
class UIRoot extends Box {
	private var scene: Scene;

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		this.scene.loop.render(HUD, this);
	}

	@:allow(engine.SceneManager)
	private function onSceneEnter() {}

	@:allow(engine.SceneManager)
	private function onSceneSuspend() {
		this.disabled = true;
	}

	@:allow(engine.SceneManager)
	private function onSceneResume() {
		this.disabled = false;
	}

	@:allow(engine.SceneManager)
	private function onSceneDestroy() {
		this.remove();
	}
}
