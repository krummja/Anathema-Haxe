package scenes;

import core.KeyCode;
import core.Scene;
import core.Frame;


class LoadingScene extends Scene
{
    private var loading: h2d.Text;

    public function new() {}

    public override function onEnter(): Void
    {
        this.loading = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
        this.loading.setScale(1);
        this.loading.text = "Loading...";
        this.loading.color = new h3d.Vector4(1, 0.3, 1);

        this.loop.render(HUD, this.loading);
    }

    private override function update(frame: Frame): Void
    {
        this.loading.textAlign = Center;
        this.loading.x = (this.camera.width / 2) / 2;
        this.loading.y = (this.camera.height / 2) * 0.9;
    }

    private override function onKeyDown(key: KeyCode): Void
    {
        if (key == KEY_N)
        {
            this.loop.world.start();
            this.start();
        }
    }

    private override function onDestroy(): Void
    {
        this.loading.remove();
    }

    private function start(): Void
    {
        this.loop.scenes.set(new TestScene());
    }
}
