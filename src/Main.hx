import engine.SettingsManager;
import engine.ColorPaletteResources;
import engine.TileResources;
import hxd.Res;
import engine.Commands;
import engine.MainLoop;
import scenes.TestScene;

class Main extends hxd.App {
	public static function main(): Void {
		Res.initLocal();
		new Main();
	}

	private var loop: MainLoop;

	public override function init(): Void {
		SettingsManager.init("settings");

		var window = hxd.Window.getInstance();

		ColorPaletteResources.init();
		TileResources.init();
		Commands.init();

		var window = hxd.Window.getInstance();
		s2d.renderer.globals.set("screenH", window.height);

		window.title = SettingsManager.settings.application.title;
		window.addResizeEvent(() -> {
			s2d.renderer.globals.set("screenW", window.width);
			s2d.renderer.globals.set("screenH", window.height);
		});

		var width = SettingsManager.settings.display.resolutionWidth;
		var height = SettingsManager.settings.display.resolutionHeight;
		window.resize(width, height);

		this.loop = MainLoop.create(this);
		this.loop.scenes.set(new TestScene());
	}

	public override function update(dt: Float): Void {
		this.loop.update();
	}
}
