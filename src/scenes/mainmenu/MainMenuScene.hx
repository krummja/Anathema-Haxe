package scenes.mainmenu;

import domain.World;
import engine.Scene;
import scenes.adventure.AdventureScene;
import scenes.options.OptionsScene;

class MainMenuScene extends Scene {
	public function new() {}

	public override function onEnter() {
		mountView();
	}

	public override function onDestroy() {
		this.ui.removeChildren();
		this.ui.remove();
	}

	private function mountView(): Void {
		var mainMenu = new MainMenuView(this);

		mainMenu.onStartClick = function(e) {
			okay();
		}
		mainMenu.onOptionsClick = function(e) {
			options();
		}
		mainMenu.onQuitClick = function(e) {
			quit();
		}

		this.ui.addComponent(mainMenu);
	}

	private function okay() {
		var seed = Std.random(0xffffff);

		// Setup save info
		loop.files.deleteSave("test");
		loop.files.setSaveName("test");

		// Initialize world
		loop.setWorld(new World());
		loop.world.initialize();
		loop.world.start(seed);

		// Go!
		loop.scenes.set(new AdventureScene());
	}

	private function options() {
		loop.scenes.push(new OptionsScene());
	}

	private function quit() {
		loop.requestExit();
	}
}
