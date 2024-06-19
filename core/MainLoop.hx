package core;

import data.ColorKey;
import data.ColorPaletteKey;
import data.ColorPaletteResources;
import domain.World;


class MainLoop
{
    public static var instance: MainLoop;

    public static function Create(app: hxd.App): MainLoop
    {
        if (instance != null) return instance;
        return new MainLoop(app);
    }

    public var PALETTE_KEY: ColorPaletteKey = PALETTE_ANATHEMA;
    public var CLEAR_COLOR: ColorKey = C_CLEAR;
    public var UNIT_X: Int = 16;
    public var UNIT_Y: Int = 16;

    public var app(default, null): hxd.App;
    public var window(get, never): hxd.Window;

    public var palette(get, null): ColorPalette;
    public var frame(default, null): Frame;
    public var camera(default, null): Camera;
    public var scenes(default, null): SceneManager;
    public var audio(default, null): AudioManager;
    public var input(default, null): InputManager;
    public var commands(default, null): CommandManager;
    public var layers(default, null): RenderLayerManager;
    public var world(default, null): World;

    public var ecs(default, null): core.ecs.Engine;

    public function new(app: hxd.App)
    {
        instance = this;
        this.app = app;

        this.frame = new Frame();
        this.audio = new AudioManager();
        this.scenes = new SceneManager();
        this.input = new InputManager();
        this.commands = new CommandManager();
        this.layers = new RenderLayerManager();
        this.camera = new Camera();

        this.world = new World();
        this.ecs = new core.ecs.Engine();

        this.app.s2d.scaleMode = Fixed(800, 600, 1, Left, Top);
        this.app.s2d.addChild(this.layers.root);
    }

    public inline function update(): Void
    {
        this.frame.update();
        this.scenes.current.update(this.frame);
    }

    public inline function render(layer: RenderLayerType, ob: h2d.Object): Void
    {
        return this.layers.render(layer, ob);
    }

    private function get_window(): hxd.Window
    {
        return hxd.Window.getInstance();
    }

    private function get_palette(): ColorPalette
    {
        return ColorPaletteResources.Get(PALETTE_KEY);
    }
}
