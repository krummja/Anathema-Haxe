package scenes.options.components;

import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.containers.Box;
import engine.Scene;

@:build(haxe.ui.macros.ComponentMacros.build("./options.xml"))
class OptionsView extends Box {
	private var scene: Scene;

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		this.scene.loop.render(HUD, this);
	}

	@:bind(btnBack, MouseEvent.CLICK)
	private function onBackClick(value: MouseEvent) {}

	@:bind(btnSave, MouseEvent.CLICK)
	private function onSaveClick(value: MouseEvent) {}
}
