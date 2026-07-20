import hxd.Res;
import haxe.ui.Toolkit;
import scenes.mainmenu.MainMenuScene;
import engine.BehaviorManager.Behaviors;
import engine.TextResources;
import engine.SettingsManager;
import engine.ColorPaletteResources;
import engine.TileResources;
import engine.Commands;
import engine.MainLoop;
import engine.Factions;
import data.Bitmasks;

class Main extends hxd.App {
	public static function main(): Void {
		Res.initLocal();
		new Main();
	}

	private var loop: MainLoop;

	public override function init(): Void {
		SettingsManager.init("settings");

		s2d.renderer.globals.set("daylight", 1);
		s2d.renderer.globals.set("dayProgress", 0);
		s2d.renderer.globals.set("time", 0);
		s2d.renderer.globals.set("clearColor", 0xff00ff.toHxdColor().toVector());

		ColorPaletteResources.init();
		TextResources.init();
		TileResources.init();
		Bitmasks.init();
		Commands.init();
		Behaviors.init();
		Factions.init();

		var window = hxd.Window.getInstance();
		s2d.renderer.globals.set("screenH", window.height);

		window.title = SettingsManager.settings.application.title;
		window.addResizeEvent(() -> {
			s2d.renderer.globals.set("screenW", window.width);
			s2d.renderer.globals.set("screenH", window.height);
		});

		this.loop = MainLoop.create(this);

		Toolkit.theme = "anathema";
		Toolkit.init({root: this.loop.layers.root});

		this.loop.scenes.set(new MainMenuScene());

		trace("App initialized - launching");
	}

	public override function update(dt: Float): Void {
		this.loop.update();
	}

	@:allow(engine.MainLoop)
	private function requestExit() {
		dispose();
	}
}
