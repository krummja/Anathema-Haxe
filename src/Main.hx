import common.util.MathLib;
import core.Frame;
import core.MainLoop;
import core.RenderLayerManager;
import data.AudioResources;
import data.Commands;
import data.TileResources;
import domain.World;
import hxd.Res;
import scenes.SplashScene;


class Debug
{
    private var loop: MainLoop;
    private var fpsText: h2d.Text;

    public function new(loop: MainLoop)
    {
        this.loop = loop;
        this.fpsText = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
        this.fpsText.setScale(1);
        this.loop.render(HUD, this.fpsText);
    }

    @:allow(Main)
    private function update(): Void
    {
        this.fpsText.textAlign = Left;
        this.fpsText.x = 4;
        this.fpsText.y = 4;
        this.fpsText.text = 'FPS: ${MathLib.pretty(this.loop.frame.fps, 2)}';
    }
}


class Main extends hxd.App
{
    public static function main(): Void
    {
        Res.initEmbed();
        new Main();
    }

    public var layers(default, null): RenderLayerManager;
    public var world(default, null): domain.World;

    private var loop: core.MainLoop;
    private var debug: Debug;

    public override function init(): Void
    {
        TileResources.Init();
        AudioResources.Init();
        Commands.Init();

        hxd.Window.getInstance().title = "Anathema";

        this.loop = core.MainLoop.Create(this);
        this.world = new World();
        this.world.initialize();
        this.loop.scenes.set(new SplashScene());

        this.debug = new Debug(this.loop);
    }

    public override function update(dt: Float): Void
    {
        this.loop.update();
        this.world.update();

        this.debug.update();
    }
}
