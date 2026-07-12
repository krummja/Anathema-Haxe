package scenes.test;

import common.tools.Performance;
import domain.components.IsCreature;
import h2d.Text;
import h2d.Object;
import emitter.Emitter;
import common.algorithm.Distance;
import domain.components.Collider;
import common.algorithm.AStar;
import common.struct.Coordinate;
import engine.TextResources;
import engine.KeyCode;
import domain.events.ConsumeEnergyEvent;
import domain.components.Path;
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
	turn: Text,
	clock: Text,
}

class TestScene extends Scene {
	public var energySystem(get, never): EnergySystem;

	private var cameraLocked: Bool = false;
	private var hudText: HudText;
	private var graphics: h2d.Graphics;

	public function new() {
		emitter = new Emitter();
	}

	private override function onEnter(): Void {
		renderText();
		world.systems.vision.computeVision();

		graphics = new h2d.Graphics();
		loop.render(HUD, graphics);
	}

	private override function onDestroy(): Void {}

	private override function update(frame: Frame): Void {
		loop.world.update();

		var mpos = loop.input.mouse;
		var zpos = mpos.toZone().toIntPoint();
		var wpos = mpos.toWorld().toIntPoint();
		var cpos = mpos.toChunk().toIntPoint();
		var turn = loop.world.clock.turn;

		hudText.fps.text = frame.smoothFps.floor().toString();
		hudText.wpos.text = 'world ' + wpos.toString();
		hudText.zpos.text = 'zone  ' + zpos.toString();
		hudText.cpos.text = 'chunk ' + cpos.toString();
		hudText.turn.text = 'turn  ' + turn.toString();

		if (world.timeStopped) {
			hudText.clock.text = "PAUSED";
		} else {
			hudText.clock.text = world.clock.toFriendlyString();
		}

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
			updateCamera(frame);
		}

		// var pos = world.player.pos.toScreen();
		// graphics.clear();
		// graphics.lineStyle(2, 0xff0000);
		// graphics.drawCircle(pos.x, pos.y, 2);
	}

	private function updateCamera(frame: Frame): Void {
		var cfocus = loop.camera.focus.toWorld().toFloatPoint();
		var ctarget = loop.world.player.pos.toFloatPoint();
		loop.camera.focus = cfocus.lerp(ctarget, 0.28).asWorld();
	}

	private override function onKeyDown(key: KeyCode) {
		if (key == KEY_NUM_1) {
			cameraLocked = !cameraLocked;
		}

		if (key == KEY_NUM_2) {
			world.timeStopped = !world.timeStopped;
		}
	}

	private override function onMouseDown(pos: Coordinate) {
		var p = astar(pos);
		if (p.success) {
			world.player.entity.remove(Path);
			world.player.entity.add(new Path(p.path));
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

		if (world.isOutOfBounds(target)) {
			return;
		}

		var entities = world.getEntitiesAt(target);

		var collider = entities.find((e) -> e.has(Collider));

		if (collider != null) {
			// TODO Door Collider
			return;
		}

		var other = entities.find((e) -> e.has(IsCreature));

		if (other != null) {
			other.add(new Move(world.player.pos, 0.1, EASE_INSTANT));
			var eMove = EnergySystem.getEnergyCost(other, ACT_SWAPPED);
			other.fireEvent(new ConsumeEnergyEvent(eMove));
		}

		world.player.entity.add(new Move(target.asWorld(), 0.1, EASE_INSTANT));
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

		var turn = new Text(TextResources.BIZCAT, ob);
		turn.color = 0xffffff.toHxdColor();
		turn.y = 64;

		var clock = new Text(TextResources.BIZCAT, ob);
		clock.color = 0xff0000.toHxdColor();
		clock.y = 80;

		hudText = {
			ob: ob,
			fps: fps,
			wpos: wpos,
			zpos: zpos,
			cpos: cpos,
			turn: turn,
			clock: clock,
		};

		loop.render(HUD, ob);
	}

	private function get_energySystem(): EnergySystem {
		return world.systems.energy;
	}

	private function astar(goal: Coordinate) {
		return AStar.getPath({
			start: world.player.pos.toWorld().toIntPoint(),
			goal: goal.toWorld().toIntPoint(),
			allowDiagonals: true,
			cost: (a, b) -> {
				if (world.isOutOfBounds(b)) {
					return Math.POSITIVE_INFINITY;
				}

				var entities = world.getEntitiesAt(b);

				if (entities.exists((e) -> e.has(Collider))) {
					return Math.POSITIVE_INFINITY;
				}

				return Distance.Diagonal(a, b);
			},
		});
	}
}
