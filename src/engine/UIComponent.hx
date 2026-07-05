package engine;

import haxe.ui.containers.Box;

abstract class UIComponent extends Box {
	private var scene: Scene;

	public abstract function update(frame: Frame): Void;
}
