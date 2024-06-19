package core;

import hxd.res.Sound;
import data.AudioResources;
import data.AudioKey;


class AudioManager
{
    public function new()
    {
        var manager = hxd.snd.Manager.get();
        manager.masterVolume = 0.0;
    }

    public function play(key: Null<AudioKey>, once: Bool = false): Void
    {
        var sound = AudioResources.Get(key);
        if (sound != null) sound.play(!once);
    }
}
