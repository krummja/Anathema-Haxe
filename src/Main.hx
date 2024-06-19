import hxd.Res;

import common.util.MathLib;
import core.Frame;
import core.MainLoop;
import core.RenderLayerManager;
import data.AudioResources;
import data.ColorPaletteResources;
import data.Commands;
import data.TileResources;
import domain.World;
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

    private var loop(get, null): core.MainLoop;

    #if debug
        private var debug: Debug;
    #end

    public override function init(): Void
    {
        TileResources.Init();
        ColorPaletteResources.Init();
        AudioResources.Init();
        Commands.Init();

        hxd.Window.getInstance().title = "Anathema";

        this.loop = core.MainLoop.Create(this);
        this.loop.world.initialize();
        this.loop.scenes.set(new SplashScene());

        #if debug
            this.debug = new Debug(this.loop);
        #end
    }

    public override function update(dt: Float): Void
    {
        this.loop.update();
        this.loop.world.update();

        #if debug
            this.debug.update();
        #end
    }

    private function get_loop(): MainLoop
    {
        return MainLoop.instance;
    }
}
