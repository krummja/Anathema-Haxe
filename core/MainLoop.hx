package core;


class MainLoop
{
    public static var instance: MainLoop;

    public static function Create(app: hxd.App): MainLoop
    {
        if (instance != null) return instance;
        return new MainLoop(app);
    }

    public var UNIT_X: Int = 16;
    public var UNIT_Y: Int = 16;

    public var app(default, null): hxd.App;
    public var window(get, never): hxd.Window;

    public var frame(default, null): Frame;
    public var camera(default, null): Camera;
    public var scenes(default, null): SceneManager;
    public var audio(default, null): AudioManager;
    public var input(default, null): InputManager;
    public var commands(default, null): CommandManager;
    public var layers(default, null): RenderLayerManager;

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

        this.app.s2d.scaleMode = Fixed(800, 600, 1, Left, Top);
        this.app.s2d.addChild(this.layers.root);
    }

    public inline function update(): Void
    {
        this.frame.update();
    }

    private function get_window(): hxd.Window
    {
        return hxd.Window.getInstance();
    }
}
