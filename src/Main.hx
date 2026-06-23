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
		var window = hxd.Window.getInstance();

		ColorPaletteResources.init();
		TileResources.init();
		Commands.init();

		this.loop = MainLoop.create(this);
		this.loop.scenes.set(new TestScene());
	}

	public override function update(dt: Float): Void {
		this.loop.update();
	}
}
