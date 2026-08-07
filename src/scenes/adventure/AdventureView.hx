package scenes.adventure;

import domain.components.Health;
import domain.components.Level;
import domain.components.Moniker;
import domain.components.Targeting;
import engine.Frame;
import engine.Scene;
import haxe.ui.containers.Box;

@:build(haxe.ui.macros.ComponentMacros.build("./components/adventure.xml"))
class AdventureView extends Box {
	private var scene: Scene;

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		this.scene.loop.render(HUD, this);
	}

	public function update(frame: Frame) {
		calculateContainerBounds();

		updatePositionInfo();
		updatePlayerHealth();
		updatePlayerLevel();
		updatePlayerXp();
		updateTargetInfo();
	}

	private function calculateContainerBounds() {
		var w = scene.camera.width - scene.camera.viewportWidth;
		var h = scene.camera.height - scene.camera.viewportHeight;
		sideContainer.width = w;
		sideContainer.height = scene.camera.height - h + 1;
		bottomContainer.height = h;
	}

	private function updatePositionInfo() {
		zoom.text = ' zoom: ${scene.camera.zoom}';
		camx.text = 'cam x: ${scene.camera.x}';
		posx.text = 'pos x: ${scene.world.player.x}';
	}

	private function updatePlayerXp() {
		var player = this.scene.player.entity;
		var level = player.get(Level);

		var current = level.xp;
		var toNextLevel = level.toNextLevel;

		xp.text = ' XP: ${current} / ${toNextLevel}';
	}

	private function updatePlayerLevel() {
		var player = this.scene.player.entity;
		var level = player.get(Level);

		var current = level.level;

		lvl.text = 'LVL: ${current}';
	}

	private function updatePlayerHealth() {
		var player = this.scene.player.entity;
		var health = player.get(Health);

		var current = health.value;
		var max = health.max;

		hp.text = ' HP: ${current} / ${max}';
	}

	private function updateTargetInfo() {
		var player = this.scene.player.entity;

		tgtname.text = "TGT: ---";
		tgthp.text = "     ---";

		if (player.has(Targeting)) {
			var targeting = player.get(Targeting);

			if (targeting.target.has(Moniker)) {
				var targetName = targeting.target.get(Moniker).displayName;
				tgtname.text = 'TGT: ${targetName}';
			}

			if (targeting.target.has(Health)) {
				var health = targeting.target.get(Health);
				var current = health.value;
				var max = health.max;
				tgthp.text = '     ${current} / ${max}';
			}
		}
	}
}
