package scenes.adventure;

// Third-party
import domain.events.MeleeEvent;
import domain.components.Attacker;
import h2d.Object;
import h2d.Text;
import emitter.Emitter;
// Internal
import common.algorithm.AStar;
import common.algorithm.Distance;
import common.struct.Cardinal;
import common.struct.Coordinate;
import domain.components.Collider;
import domain.components.IsCreature;
import domain.components.Move;
import domain.components.Path;
import domain.events.ConsumeEnergyEvent;
import domain.systems.EnergySystem;
import engine.CommandManager.Command;
import engine.Frame;
import engine.KeyCode;
import engine.Scene;
import engine.TextResources;
import scenes.options.OptionsScene;

typedef HudText = {
	ob: Object,
	fps: Text,
	wpos: Text,
	zpos: Text,
	cpos: Text,
	turn: Text,
	clock: Text,
}

typedef SidePanel = {
	ob: Object,
}

class AdventureScene extends Scene {
	public var energySystem(get, never): EnergySystem;

	private var cameraLocked: Bool = false;
	private var sidePanel: SidePanel;
	private var hudText: HudText;

	private var overlay: AdventureView;

	public function new() {
		emitter = new Emitter();
	}

	private override function onEnter(): Void {
		world.systems.vision.computeVision();
		this.overlay = new AdventureView(this);
		this.ui.addComponent(this.overlay);
	}

	private override function onDestroy(): Void {}

	private override function update(frame: Frame): Void {
		loop.world.update();

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

		this.overlay.update(frame);
	}

	private function updateCamera(frame: Frame): Void {
		var cfocus = loop.camera.focus.toWorld().toFloatPoint();
		var ctarget = loop.world.player.pos.toFloatPoint();
		loop.camera.focus = ctarget.asWorld();
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
		var screenPos = pos.toScreen();

		if (screenPos.x > camera.viewportWidth || screenPos.y > camera.viewportHeight) {
			return;
		}

		var p = astar(pos);
		if (p.success) {
			world.player.entity.remove(Path);
			world.player.entity.add(new Path(p.path));
		}
	}

	private function handle(cmd: Command): Void {
		if (cmd != null) {
			switch cmd.type {
				case CMD_CANCEL:
					pause();
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
				case CMD_CONSOLE:
					loop.scenes.push(new Console());
				case CMD_WAIT:
					EnergySystem.consumeEnergy(world.player.entity, ACT_WAIT);
				case _:
			}
		}
	}

	private function pause() {
		loop.scenes.push(new OptionsScene());
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

		// Attacker
		if (other != null) {
			var isHostile = world.factions.areEntitiesHostile(other, world.player.entity);

			if (isHostile) {
				world.player.entity.fireEvent(new MeleeEvent(other, world.player.entity));
				world.player.entity.add(new Attacker(dir));
				return;
			} else {
				other.add(new Move(world.player.pos, 0.1, EASE_INSTANT));
				var eMove = EnergySystem.getEnergyCost(other, ACT_SWAPPED);
				other.fireEvent(new ConsumeEnergyEvent(eMove));
			}
		}

		world.player.entity.add(new Move(target.asWorld(), 0.1, EASE_INSTANT));
		var cost = EnergySystem.getEnergyCost(world.player.entity, ACT_MOVE);
		world.player.entity.fireEvent(new ConsumeEnergyEvent(cost));
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
