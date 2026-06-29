package scenes;

import systems.MovementSystem;
import events.ConsumeEnergyEvent;
import components.Move;
import systems.EnergySystem;
import common.struct.Cardinal;
import engine.CommandManager.Command;
import engine.MainLoop;
import engine.KeyCode;
import engine.Frame;
import engine.Scene;

class TestScene extends Scene {
	public var energySystem(get, never): EnergySystem;

	public function new() {}

	private override function onEnter(): Void {
		MainLoop.getInstance().world.initialize();
		MainLoop.getInstance().world.start();
	}

	private override function onDestroy(): Void {}

	private override function update(?frame: Frame): Void {
		MainLoop.getInstance().world.update();
		updateCamera();

		if (energySystem.isPlayerTurn) {
			var cmd = loop.commands.peek();
			if (cmd != null) {
				trace(cmd);
				if (world.player.entity.exists(Move)) {
					var movement: MovementSystem = cast world.systems.getSystem(ON_UPDATE, MovementSystem);
					movement.finishMoveFast(world.player.entity);
				} else {
					handle(loop.commands.next());
				}
			}
		}
	}

	private function updateCamera(): Void {
		var cfocus = loop.camera.focus.toWorld().toFloatPoint();
		var ctarget = loop.world.player.pos.toFloatPoint();
		loop.camera.focus = ctarget.asWorld();
	}

	private function handle(cmd: Command): Void {
		if (cmd != null) {
			switch cmd.type {
				case CMD_MOVE_N:
					move(NORTH);
				case CMD_MOVE_NE:
					move(NORTH_EAST);
				case CMD_MOVE_E:
					move(EAST);
				case CMD_MOVE_SE:
					move(SOUTH_EAST);
				case CMD_MOVE_S:
					move(SOUTH);
				case CMD_MOVE_SW:
					move(SOUTH_WEST);
				case CMD_MOVE_W:
					move(WEST);
				case CMD_MOVE_NW:
					move(NORTH_WEST);
				case CMD_WAIT:
					trace("Wait");
				case _:
			}
		}
	}

	private function move(dir: Cardinal) {
		var target = world.player.pos.toIntPoint().add(dir.toOffset());

		var move = new Move(target.asWorld(), 0.1, EASE_LINEAR);
		move.start = world.player.pos;
		move.startTime = loop.frame.elapsed;
		world.player.entity.add(move);

		var cost = EnergySystem.getEnergyCost(world.player.entity, ACT_MOVE);
		world.player.entity.add(new ConsumeEnergyEvent(cost));
	}

	private function get_energySystem(): EnergySystem {
		return world.systems.getSystem(ON_UPDATE, EnergySystem);
	}
}
