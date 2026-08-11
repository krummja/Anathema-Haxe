package scenes.pause;

import engine.Scene;
import haxe.ui.containers.Box;
import haxe.ui.events.MouseEvent;

@:build(haxe.ui.macros.ComponentMacros.build("./components/pause.xml"))
class PauseView extends Box {
	@:allow(scenes.pause.PauseScene)
	private var onResumeClick: (MouseEvent) -> Void;

	@:allow(scenes.pause.PauseScene)
	private var onOptionsClick: (MouseEvent) -> Void;

	@:allow(scenes.pause.PauseScene)
	private var onQuitClick: (MouseEvent) -> Void;

	private var scene: Scene;

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		this.scene.loop.render(HUD, this);
	}

	@:bind(btnResume, MouseEvent.CLICK)
	private function _onResumeClick(value: MouseEvent): Void {
		if (onResumeClick != null) {
			onResumeClick(value);
		}
	}

	@:bind(btnOptions, MouseEvent.CLICK)
	private function _onOptionsClick(value: MouseEvent): Void {
		if (onOptionsClick != null) {
			onOptionsClick(value);
		}
	}

	@:bind(btnQuit, MouseEvent.CLICK)
	private function _onQuitClick(value: MouseEvent): Void {
		if (onQuitClick != null) {
			onQuitClick(value);
		}
	}
}
