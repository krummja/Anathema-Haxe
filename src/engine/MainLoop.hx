package engine;

import common.tools.Performance;
import domain.World;
import ecs.Registry;
import engine.RenderLayerManager;
import h2d.Console;

class MainLoop {
	public var UNIT_X: Int = 16;
	public var UNIT_Y: Int = 16;
	public var DIE_SIZE: Int = 12;
	public var CLEAR_COLOR: ColorKey = C_CLEAR;
	public var PALETTE_KEY: ColorPaletteKey = PALETTE_ANATHEMA;

	public static var instance: MainLoop;

	public static function getInstance(): MainLoop {
		return instance;
	}

	public static function create(app: hxd.App): MainLoop {
		if (instance != null) {
			return instance;
		}
		return new MainLoop(app);
	}

	public var app(default, null): hxd.App;
	public var window(get, never): hxd.Window;
	public var frame(default, null): Frame;
	public var camera(default, null): Camera;
	public var scenes(default, null): SceneManager;
	public var input(default, null): InputManager;
	public var commands(default, null): CommandManager;
	public var layers(default, null): RenderLayerManager;
	public var console(default, null): Console;
	public var timeout(default, null): TimeoutManager;
	public var world(default, null): World;
	public var registry(default, null): Registry;
	public var files(default, null): FileManager;
	public var palette(get, null): ColorPalette;

	private function new(app: hxd.App) {
		instance = this;
		this.app = app;

		// Instantiate core engine managers
		this.frame = new Frame();
		this.files = new FileManager();
		this.layers = new RenderLayerManager();
		this.input = new InputManager();
		this.commands = new CommandManager();
		this.camera = new Camera();
		this.world = new World();
		this.registry = new Registry();
		this.scenes = new SceneManager(this);
		this.timeout = new TimeoutManager();

		// Set up console
		this.console = new Console(TextResources.BIZCAT);
		ConsoleConfig.config(this.console);

		// Apply initial settings
		applySettings();

		// Add rendering root
		this.app.s2d.addChild(this.layers.root);

		// Register lifecycle callbacks
		window.onClose = onClose;

		window.addResizeEvent(scenes.onResize);
	}

	public inline function update(): Void {
		Performance.update(frame.dt * 1000);
		this.frame.update();
		this.scenes.update(this.frame);
	}

	public function applySettings(): Void {
		// Get settings
		var zoom = SettingsManager.settings.display.zoomLevel;
		var minWidth = SettingsManager.settings.display.resolutionWidth;
		var minHeight = SettingsManager.settings.display.resolutionHeight;

		var width = Math.max(app.s2d.renderer.globals.get("screenW"), minWidth);
		var height = Math.max(app.s2d.renderer.globals.get("screenH"), minHeight);

		// Calculate window geometry
		var columns = Math.floor(width / this.UNIT_X);
		var rows = Math.floor(height / this.UNIT_Y);
		this.camera.zoom = zoom;

		window.resize(columns * UNIT_X, rows * UNIT_Y);
		window.vsync = SettingsManager.settings.graphics.vsyncEnabled;
		window.displayMode = switch (SettingsManager.settings.display.fullScreen) {
			case "Windowed":
				Windowed;
			case "Borderless":
				Borderless;
			case "Fullscreen":
				Fullscreen;
			case _:
				Windowed;
		}
	}

	public inline function render(layer: RenderLayerType, ob: h2d.Object): Void {
		return this.layers.render(layer, ob);
	}

	public function requestExit() {
		hxd.System.exit();
	}

	@:allow(engine.Scene)
	private function setWorld(world: World) {
		this.world = world;
	}

	private function onClose(): Bool {
		trace("Shutting down... Goodbye!");
		return true;
	}

	private inline function get_window(): hxd.Window {
		return hxd.Window.getInstance();
	}

	private inline function get_palette(): ColorPalette {
		return ColorPaletteResources.get(PALETTE_KEY);
	}
}
