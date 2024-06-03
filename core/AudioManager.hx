package core;


class AudioManager
{
    public var current(default, set): Dynamic;

    public function new()
    {
        var manager = hxd.snd.Manager.get();
        manager.masterVolume = 0.1;
    }

    public function play(key: Null<String>)
    {
        var sound = this.current;
        if (sound.isNull()) return;
        sound.play();
    }

    public function set_current(value: Dynamic): Dynamic
    {
        return this.current = value;
    }
}
