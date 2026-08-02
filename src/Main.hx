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
import haxe.CallStack;
import haxe.EnumFlags;
import haxe.ui.Toolkit;
import scenes.mainmenu.MainMenuScene;
import scenes.testing.TestingScene;

class Main extends hxd.App {
	public static function main(): Void {
		new Main();
	}

	#if hl
	public static function onCrash(err: Dynamic) {
		var title = "Fatal error";
		var msg = 'The game has crashed! Error: ${Std.string(err)}';
		var flags: EnumFlags<hl.UI.DialogFlags> = new haxe.EnumFlags();
		flags.set(IsError);

		var log = [Std.string(err)];

		try {
			log.push("BUILD: "); // TODO Build info
			log.push("EXCEPTION:");
			log.push(CallStack.toString(CallStack.exceptionStack()));

			log.push("CALL:");
			log.push(CallStack.toString(CallStack.callStack()));

			sys.io.File.saveContent("crash.log", log.join("\n"));
			hl.UI.dialog(title, msg, flags);
		}
		catch (_) {
			sys.io.File.saveContent("crash2.log", log.join("\n"));
			hl.UI.dialog(title, msg, flags);
		}

		hxd.System.exit();
	}
	#end

	private var loop: MainLoop;

	public override function init(): Void {
		initEngine();

		SettingsManager.init("settings");

		initGlobals();
		initWindow();
		initAssets();

		this.loop = MainLoop.create(this);

		initUI();

		this.loop.scenes.set(new TestingScene());

		trace("App initialized - launching");
	}

	private function initEngine(): Void {
		engine.backgroundColor = 0xff << 24 | 0x111133;

		#if (hl)
		engine.fullScreen = true;
		// hl.UI.closeConsole();
		hl.Api.setErrorHandler(onCrash);
		hxd.Res.initLocal();
		#else
		hxd.Res.initEmbed();
		#end

		// Sound manager (force manager init on startup to avoid freeze on first sound playback)
		hxd.snd.Manager.get();
		// Needed to ignore heavy sound manager init frame
		hxd.Timer.skip();

		hxd.Timer.smoothFactor = 0.4;
		hxd.Timer.wantedFPS = Std.int(hxd.System.getDefaultFrameRate());
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
