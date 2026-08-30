package scenes.dev;

import engine.Scene;

class DevScene extends Scene {
	public function new() {}

	public override function onEnter() {
		mountView();
	}

	private function mountView(): Void {
		var view = new DevView(this);

		this.ui.addComponent(view);
	}

	private function quit() {
		loop.requestExit();
	}
}
