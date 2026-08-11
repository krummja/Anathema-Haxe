package scenes.pause;

import engine.Scene;

class PauseScene extends Scene {
	private var view: scenes.pause.PauseView;

	public function new() {}

	public override function onEnter() {
		view = new PauseView(this);

		view.onResumeClick = function(e) {
			loop.scenes.pop();
		}

		view.onQuitClick = function(e) {
			loop.requestExit();
		}

		ui.addComponent(view);
	}

	public override function onDestroy() {
		view = null;
		ui.removeChildren();
		ui.remove();
	}
}
