import data.Commands;
import data.TextResources.TileResources;
import scenes.TestScene;
import hxd.Res;
import ecs.Engine;
import core.RenderLayerManager;


class Main extends hxd.App
{
    public static function main(): Void
    {
        Res.initEmbed();
        new Main();
    }

    public var ecs(default, null): Engine;
    public var layers(default, null): RenderLayerManager;

    private var loop: core.MainLoop;

    public override function init(): Void
    {
        TileResources.Init();
        Commands.Init();

        hxd.Window.getInstance().title = "Anathema";

        this.loop = core.MainLoop.Create(this);
        this.loop.scenes.set(new TestScene());
    }

    public override function update(dt: Float): Void
    {
        this.loop.update();
    }
}
