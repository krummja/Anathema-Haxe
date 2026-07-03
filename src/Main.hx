import haxe.ui.Toolkit;
import scenes.boot.BootScene;
import data.Bitmasks;
import engine.BehaviorManager.Behaviors;
import engine.TextResources;
import engine.SettingsManager;
import engine.ColorPaletteResources;
import engine.TileResources;
import hxd.Res;
import engine.Commands;
import engine.MainLoop;

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

		var window = hxd.Window.getInstance();

		ColorPaletteResources.init();
		TextResources.init();
		TileResources.init();
		Bitmasks.init();
		Commands.init();
		Behaviors.init();

		var window = hxd.Window.getInstance();
		s2d.renderer.globals.set("screenH", window.height);

		window.title = SettingsManager.settings.application.title;
		window.addResizeEvent(() -> {
			s2d.renderer.globals.set("screenW", window.width);
			s2d.renderer.globals.set("screenH", window.height);
		});

		this.loop = MainLoop.create(this);
		Toolkit.init({root: this.loop.layers.root});
		this.loop.scenes.set(new BootScene());

		trace("App initialized - launching");
	}

	public override function update(dt: Float): Void {
		this.loop.update();
	}
}
