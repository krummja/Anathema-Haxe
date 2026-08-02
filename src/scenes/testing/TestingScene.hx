package scenes.testing;

import engine.Frame;
import engine.Scene;

class TestingScene extends Scene {
	private var view: TestingView;

	public function new() {}

	public override function onEnter(): Void {
		view = new TestingView(this);
		this.ui.addComponent(view);
	}

	public override function onDestroy(): Void {}

	public override function update(frame: Frame): Void {
		view.update(frame);
	}
}
