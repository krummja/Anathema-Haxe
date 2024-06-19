package data;

import hxd.res.Sound;


class AudioResources
{
    public static var audio: Map<AudioKey, Sound> = [];

    public static function Get(type: AudioKey): Sound
    {
        if (type.isNull()) return null;
        return audio.get(type);
    }

    public static function Init(): Void
    {
        if (hxd.res.Sound.supportedFormat(OggVorbis))
        {
            var r = hxd.Res.sound;
            audio.set(MUSIC_01, r.test_music);
        }

        else trace("OggVorbis NOT SUPPORTED");
    }
}
