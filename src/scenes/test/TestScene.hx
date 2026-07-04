package scenes.test;

import engine.TextResources;
import h2d.Text;
import h2d.Object;
import engine.KeyCode;
import domain.events.ConsumeEnergyEvent;
import domain.components.Move;
import domain.systems.EnergySystem;
import common.struct.Cardinal;
import engine.CommandManager.Command;
import engine.Frame;
import engine.Scene;

typedef HudText = {
	ob: Object,
	fps: Text,
	wpos: Text,
	zpos: Text,
	cpos: Text,
}

class TestScene extends Scene {
	public var energySystem(get, never): EnergySystem;

	private var cameraLocked: Bool = false;
	private var hudText: HudText;

	public function new() {}

	private override function onEnter(): Void {
		renderText();
		world.systems.vision.computeVision();
	}

	private override function onDestroy(): Void {}

	private override function update(frame: Frame): Void {
		loop.world.update();

		var mpos = loop.input.mouse;
		var zpos = mpos.toZone().toIntPoint();
		var wpos = mpos.toWorld().toIntPoint();
		var cpos = mpos.toChunk().toIntPoint();

		hudText.fps.text = frame.fps.floor().toString();
		hudText.wpos.text = 'world ' + wpos.toString();
		hudText.zpos.text = 'zone  ' + zpos.toString();
		hudText.cpos.text = 'chunk ' + cpos.toString();

		if (energySystem.isPlayersTurn) {
			var cmd = loop.commands.peek();
			if (cmd != null) {
				if (world.player.entity.has(Move)) {
					world.systems.movement.finishMoveFast(world.player.entity);
				} else {
					handle(loop.commands.next());
				}
			}
		}

		if (!cameraLocked) {
			updateCamera();
		}
	}

	private function updateCamera(): Void {
		var cfocus = loop.camera.focus.toWorld().toFloatPoint();
		var ctarget = loop.world.player.pos.toFloatPoint();
		loop.camera.focus = cfocus.lerp(ctarget, 0.2).asWorld();
	}

	private override function onKeyDown(key: KeyCode) {
		if (key == KEY_NUM_1) {
			cameraLocked = !cameraLocked;
		}
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
		var entities = world.getEntitiesAt(target);

		world.player.entity.add(new Move(target.asWorld(), 0.1, EASE_LINEAR));
		var cost = EnergySystem.getEnergyCost(world.player.entity, ACT_MOVE);
		world.player.entity.fireEvent(new ConsumeEnergyEvent(cost));
	}

	private function renderText() {
		var ob = new Object();
		ob.x = 16;
		ob.y = 16;

		var fps = new Text(TextResources.BIZCAT, ob);
		fps.color = 0xffffff.toHxdColor();
		fps.y = 0;

		var wpos = new Text(TextResources.BIZCAT, ob);
		wpos.color = 0xffffff.toHxdColor();
		wpos.y = 16;

		var zpos = new Text(TextResources.BIZCAT, ob);
		zpos.color = 0xffffff.toHxdColor();
		zpos.y = 32;

		var cpos = new Text(TextResources.BIZCAT, ob);
		cpos.color = 0xffffff.toHxdColor();
		cpos.y = 48;

		hudText = {
			ob: ob,
			fps: fps,
			wpos: wpos,
			zpos: zpos,
			cpos: cpos,
		};

		loop.render(HUD, ob);
	}

	private function get_energySystem(): EnergySystem {
		return world.systems.energy;
	}
}
