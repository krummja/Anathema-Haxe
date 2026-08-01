import data.Bitmasks;
import domain.abilities.Abilities;
import domain.stats.Stats;
import domain.weapons.Weapons;
import engine.BehaviorManager.Behaviors;
import engine.ColorPaletteResources;
import engine.Commands;
import engine.Factions;
import engine.MainLoop;
import engine.SettingsManager;
import engine.TextResources;
import engine.TileResources;
import haxe.ui.Toolkit;
import hxd.Res;
import scenes.mainmenu.MainMenuScene;

class Main extends hxd.App {
	public static function main(): Void {
		Res.initLocal();
		new Main();
	}

	private var loop: MainLoop;

	public override function init(): Void {
		SettingsManager.init("settings");

		initGlobals();
		initWindow();
		initAssets();

		this.loop = MainLoop.create(this);

		initUI();

		this.loop.scenes.set(new MainMenuScene());

		trace("App initialized - launching");
	}

	private function initGlobals(): Void {
		s2d.renderer.globals.set("daylight", 1);
		s2d.renderer.globals.set("dayProgress", 0);
		s2d.renderer.globals.set("time", 0);
		s2d.renderer.globals.set("clearColor", 0xff00ff.toHxdColor().toVector());
	}

	private function initWindow(): Void {
		var window = hxd.Window.getInstance();
		s2d.renderer.globals.set("screenH", window.height);

		window.title = SettingsManager.settings.application.title;
		window.addResizeEvent(() -> {
			s2d.renderer.globals.set("screenW", window.width);
			s2d.renderer.globals.set("screenH", window.height);
		});
	}

	private function initAssets(): Void {
		TextResources.init();
		TileResources.init();
		ColorPaletteResources.init();
		Bitmasks.init();
		Commands.init();
		Stats.init();
		Abilities.init();
		Weapons.init();
		Behaviors.init();
		Factions.init();
	}

	private function initUI(): Void {
		Toolkit.theme = "anathema";
		Toolkit.init({root: this.loop.layers.root});
	}

	public override function update(dt: Float): Void {
		this.loop.update();
	}

	@:allow(engine.MainLoop)
	private function requestExit() {
		dispose();
	}
}
