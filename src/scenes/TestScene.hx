package scenes;

import common.struct.Cardinal;
import events.ConsumeEnergyEvent;
import engine.CommandManager.Command;
import engine.MainLoop;
import engine.Frame;
import engine.Scene;
import components.Move;
import systems.MovementSystem;
import systems.EnergySystem;

class TestScene extends Scene {
	public var energySystem(get, never): EnergySystem;

	public function new() {}

	private override function onEnter(): Void {
		MainLoop.getInstance().world.initialize();

		var seed = Std.random(0xffffff);
		MainLoop.getInstance().world.start(seed);
	}

	private override function onDestroy(): Void {}

	private override function update(?frame: Frame): Void {
		MainLoop.getInstance().world.update();

		if (energySystem.isPlayerTurn) {
			var cmd = loop.commands.peek();
			if (cmd != null) {
				if (world.player.entity.exists(Move)) {
					var movement: MovementSystem = cast world.systems.getSystem(ON_UPDATE, MovementSystem);
					movement.finishMoveFast(world.player.entity);
				} else {
					handle(loop.commands.next());
				}
			}
		}

		updateCamera();
	}

	private function updateCamera(): Void {
		var cfocus = loop.camera.focus.toWorld().toFloatPoint();
		var ctarget = loop.world.player.pos.toFloatPoint();
		loop.camera.focus = cfocus.lerp(ctarget, 0.2).asWorld();
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
					EnergySystem.consumeEnergy(world.player.entity, ACT_WAIT);
				case _:
			}
		}
	}

	private function move(dir: Cardinal) {
		var target = world.player.pos.toIntPoint().add(dir.toOffset());

		world.player.entity.add(new Move(target.asWorld(), 0.1, EASE_LINEAR));

		var cost = EnergySystem.getEnergyCost(world.player.entity, ACT_MOVE);
		world.player.entity.fireEvent(new ConsumeEnergyEvent(cost));
	}

	private function get_energySystem(): EnergySystem {
		return world.systems.getSystem(ON_UPDATE, EnergySystem);
	}
}
