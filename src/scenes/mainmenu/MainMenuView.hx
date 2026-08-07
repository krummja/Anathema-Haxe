package scenes.mainmenu;

import engine.Scene;
import haxe.ui.components.Label;
import haxe.ui.containers.Box;
import scenes.Events;

@:build(haxe.ui.macros.ComponentMacros.build("./components/main_menu.xml"))
class MainMenuView extends Box {
	public var onStartClick(default, set): ClickEvent;
	public var onOptionsClick(default, set): ClickEvent;
	public var onQuitClick(default, set): ClickEvent;

	private var scene: Scene;

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		this.scene.loop.render(HUD, this);
	}

	private function set_onStartClick(value: ClickEvent): ClickEvent {
		start.onClick = value;
		return value;
	}

	private function set_onOptionsClick(value: ClickEvent): ClickEvent {
		options.onClick = value;
		return value;
	}

	private function set_onQuitClick(value: ClickEvent): ClickEvent {
		quit.onClick = value;
		return value;
	}
}
