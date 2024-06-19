package scenes;

import h3d.Vector4;
import h2d.Bitmap;
import data.TileResources;
import data.AudioResources;
import common.util.Timeout;
import common.struct.Coordinate;
import core.Frame;
import core.KeyCode;
import core.Scene;


class SplashScene extends Scene
{
    private var title: h2d.Text;
    private var next: h2d.Text;
    private var duration: Float;
    private var timeout: Timeout;

    public function new(duration: Float = 3)
    {
        this.duration = duration;
        this.timeout = new Timeout(2);
        this.timeout.onComplete = this.timeout.reset;
    }

    private override function onEnter(): Void
    {
        this.title = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
        this.title.setScale(3);
        this.title.text = "Anathema";
        this.title.color = new h3d.Vector4(1, 1, 0.9);

        this.next = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
        this.next.setScale(1);
        this.next.text = "click anywhere to continue";
        this.next.color = new h3d.Vector4(1, 1, 0.9);

        this.loop.render(HUD, this.title);
        this.loop.render(HUD, this.next);
        this.loop.audio.play(MUSIC_01);
    }

    private override function update(frame: Frame): Void
    {
        this.timeout.update();
        this.duration -= frame.dt;

        this.title.textAlign = Center;
        this.title.x = (this.camera.width / 2) / this.camera.zoom;
        this.title.y = (this.camera.height / 2) / this.camera.zoom;

        this.next.textAlign = Center;
        this.next.x = (this.camera.width / 2) / this.camera.zoom;
        this.next.y = (this.camera.height / 2 + 128) / this.camera.zoom;
    }

    private override function onMouseUp(pos: Coordinate): Void
    {
        this.okay();
    }

    private override function onKeyDown(key: KeyCode): Void
    {
        this.okay();
    }

    private function okay(): Void
    {
        this.loop.scenes.set(new LoadingScene());
    }

    private override function onDestroy(): Void
    {
        this.title.remove();
        this.next.remove();
    }
}
