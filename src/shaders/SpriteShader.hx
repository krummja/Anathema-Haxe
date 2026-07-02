package shaders;

import engine.ColorKey;
import engine.MainLoop;

class SpriteShader extends hxsl.Shader {
    // @formatter:off
    private static var SRC = {
        var pixelColor: Vec4;

        @param var primary: Vec3;
		@param var secondary: Vec3;
		@param var outline: Vec3;
		@param var background: Vec3;
        @param var clearBackground: Int;

        @param var isShrouded: Int;
        @param var shroudColor: Vec3;
        @param var isLit: Int;
        @param var lut: Sampler2D;
        @param var lutSize: Int;
        @param var lightColor: Vec3;
        @param var lightIntensity: Float;
        @param var ignoreLighting: Int;
        @param var seed: Int;

        @param var time: Float;
        @param var dayLight: Float;
        @param var dayProgress: Float;

        function fragment() {
            var color = pixelColor.rgb;
            var alpha = pixelColor.a;

            // Source pixel is transparent
            var isBackground = alpha == 0;

            // Source pixel is white
            var isPrimary = !isBackground && color.r == 1 && color.g == 1 && color.b == 1;

            // Source pixel is black
            var isSecondary = !isBackground && color.r == 0 && color.g == 0 && color.b == 0;

            // Source pixel is red
            var isOutline = !isBackground && color.r == 1 && color.g == 0 && color.b == 0;

            var t1 = ((sin((time) * 2) + 1) / 2) * 0.85;
            var t2 = ((sin((time + seed) * 24) + 1) / 2) * 0.15;
            var t = (t1 + t2);

            var scaled = 0.5 + (t * 0.5);
            var nightIntensity = (1 - dayLight) * 0.75;
            var intensity = (scaled * lightIntensity);

            if (sin((time + seed) * 0.8) > -0.025 && sin((time + seed) * 0.8) < 0.025) {
                intensity = intensity * 0.75;
            }

            var c = color;
            var applyLighting = ignoreLighting == 0;

            if (isPrimary) {
                color = primary;
            }

            else if (isSecondary) {
                color = secondary;
            }

            else if (isOutline) {
                color = outline;
                applyLighting = false;
            }

            else if (isBackground) {
                if (clearBackground == 1) {
                    color = background;
                    pixelColor.a = 1;
                    applyLighting = false;
                }
            }

            // Source pixel is magenta
            if (color.r == 1.0 && color.g == 0.0 && color.b == 1.0) {
                color = background;
                alpha = 1;
                applyLighting = false;
            }

            if (applyLighting) {
                if (isLit == 1) {
                    var i = (intensity * nightIntensity) * 0.76;
                    color = mix(color, lightColor, i);
                    nightIntensity = nightIntensity * (1 - intensity);
                }

                if (isShrouded == 1) {
                    color = mix(color, shroudColor, 0.925);
                }

                var lutY = 1 - color.g;
                var lutX = (floor(color.b * 32) / 32) + (color.r / 32);
                var uvv = vec2(lutX, lutY);
                var nightColor = lut.get(uvv).rgb;
                color = mix(color, nightColor, nightIntensity);
            }

            pixelColor.rgb = color;
            pixelColor.a = alpha;
        }
    };

    public function new(
        primary: Int = 0x000000,
        secondary: Int = 0xffffff,
        outline: Int = 0x000000,
        background: Int = 0x212121,
    ) {
        super();
		this.primary = primary.toHxdColor().toVector();
		this.secondary = secondary.toHxdColor().toVector();
        this.shroudColor = ColorKey.C_SHROUD.toHxdColor().toVector();
        this.isShrouded = 0;
        this.isLit = 1;
        this.ignoreLighting = 1;
        this.lightColor = ColorKey.C_BRIGHT_WHITE.toHxdColor().toVector();
        this.lightIntensity = 1;
        this.seed = MainLoop.getInstance().world.rand.integer(0, 10000);
        this.lut = hxd.Res.images.lut.lut_night.toTexture();
		this.outline = outline.toHxdColor().toVector();
		this.background = background.toHxdColor().toVector();
        this.clearBackground = 1;
    }

    public function setShrouded(value: Bool) {
        isShrouded = value ? 1 : 0;
    }
    // @formatter:on
}
