package scenes.cursor;

import common.struct.Cardinal;
import common.struct.Coordinate;
import common.struct.IntPoint;
import engine.CommandManager.Command;
import engine.Scene;

typedef CursorRenderOpts = {
	var start: Coordinate;
	var end: Coordinate;
	var line: Array<IntPoint>;
}

class CursorScene extends Scene {
	public var start: Coordinate;
	public var target: Coordinate;

	private var lookahead: Coordinate;

	public function new() {
		inputDomain = INPUT_DOMAIN_DEFAULT;
		start = world.player.pos.floor();
		target = start;
		lookahead = start;
	}

	public override function onMouseMove(pos: Coordinate, previous: Coordinate) {
		if (pos.x >= loop.camera.viewportWidth || pos.y >= loop.camera.viewportHeight) {
			return;
		}

		target = pos.toWorld().floor();
	}

	private function look(dir: Cardinal) {
		lookahead = target.add(dir.toOffset().asWorld());
		var screenPos = lookahead.toScreen();

		if (screenPos.x >= loop.camera.viewportWidth || screenPos.y >= loop.camera.viewportHeight) {
			return;
		}

		if (screenPos.x < 0 || screenPos.y < 0) {
			return;
		}

		target = lookahead;
	}

	private function render(opts: CursorRenderOpts) {}

	private function handle(command: Command) {
		switch (command.type) {
			case CMD_MOVE_NW:
				look(NORTH_WEST);
			case CMD_MOVE_N:
				look(NORTH);
			case CMD_MOVE_NE:
				look(NORTH_EAST);
			case CMD_MOVE_E:
				look(EAST);
			case CMD_MOVE_W:
				look(WEST);
			case CMD_MOVE_SW:
				look(SOUTH_WEST);
			case CMD_MOVE_S:
				look(SOUTH);
			case CMD_MOVE_SE:
				look(SOUTH_EAST);
			case CMD_LOOK:
				loop.scenes.pop();
			case CMD_CANCEL:
				loop.scenes.pop();
			case _:
		}
	}
}
