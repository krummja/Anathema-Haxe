package systems;

import echoes.System;
import echoes.Entity;
import components.Position;
import components.Sprite;

class RenderSystem extends System {
	public var loop(get, never): engine.MainLoop;

	@:add private function onDisplayAdded(display: Sprite): Void {
		this.loop.render(display.layer, display.drawable);
	}

	@:remove private function onDisplayRemoved(display: Sprite): Void {
		display.drawable.remove();
	}

	@:update private function updatePosition(display: Sprite, position: Position): Void {
		var coord = engine.Projection.worldToPixel(position.x, position.y);
		display.setPosition(coord.x, coord.y);
	}

	private function get_loop(): engine.MainLoop {
		return engine.MainLoop.getInstance();
	}
}
