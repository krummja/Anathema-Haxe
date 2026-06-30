package engine;

import h2d.Console;
import engine.RenderLayerManager;

class MainLoop {
	public var UNIT_X: Int = 16;
	public var UNIT_Y: Int = 16;
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
	public var palette(get, null): ColorPalette;

	private function new(app: hxd.App) {
		instance = this;
		this.app = app;

		this.frame = new Frame();
		this.layers = new RenderLayerManager();
		this.input = new InputManager();
		this.commands = new CommandManager();
		this.camera = new Camera();
		this.world = new World();
		this.scenes = new SceneManager(this);
		this.timeout = new TimeoutManager();

		this.console = new Console(TextResources.BIZCAT);
		ConsoleConfig.config(this.console);

		var zoom = SettingsManager.settings.display.zoomLevel;
		var width = SettingsManager.settings.display.resolutionWidth;
		var height = SettingsManager.settings.display.resolutionHeight;

		var columns = Math.floor(width / this.UNIT_X);
		var rows = Math.floor(height / this.UNIT_Y);
		this.camera.zoom = zoom;

		window.resize(columns * UNIT_X, rows * UNIT_Y);
		this.app.s2d.addChild(this.layers.root);
	}

	/**
	 * Runs update on all attached managers.
	 *
	 * 1. Frame
	 * 2. SceneManager
	 * 	- Current Scene Handle Input
	 * 	- Current Scene Update
	 */
	public inline function update(): Void {
		this.frame.update();
		this.scenes.update(this.frame);
	}

	public inline function render(layer: RenderLayerType, ob: h2d.Object): Void {
		return this.layers.render(layer, ob);
	}

	private inline function get_window(): hxd.Window {
		return hxd.Window.getInstance();
	}

	private inline function get_palette(): ColorPalette {
		return ColorPaletteResources.get(PALETTE_KEY);
	}
}
