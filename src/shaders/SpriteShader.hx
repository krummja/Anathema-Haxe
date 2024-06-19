package shaders;

import core.MainLoop;


class SpriteShader extends hxsl.Shader
{
    private static var SRC = {
        @:import h3d.shader.Base2d;

        @param var primary: Vec4;
        @param var secondary: Vec4;
        @param var outline: Vec4;
        @param var background: Vec4;
        @param var clearBackground: Int;
        @param var enableLut: Int;

        // BLACK -> primary color
        // WHITE -> secondary color
        function fragment()
        {
            var isBackground = pixelColor.a == 0;
            var isPrimary = !isBackground && pixelColor.r == 0 && pixelColor.g == 0 && pixelColor.b == 0;
            var isSecondary = !isBackground && pixelColor.r == 1 && pixelColor.g == 1 && pixelColor.b == 1;
            var isOutline = !isBackground && pixelColor.r == 1 && pixelColor.g == 0 && pixelColor.b == 0;

            var baseColor = pixelColor.rgba;

            if (isPrimary) baseColor = primary;
            else if (isSecondary) baseColor = secondary;
            else if (isOutline)
            {
                baseColor = outline;
                pixelColor.a = 0.75;
            }
            else if (isBackground) baseColor = mix(background, vec4(0, 0, 0, 0), 0.25);

            pixelColor.rgb = baseColor.rgb;
        }
    }

    public function new(primary: Int = 0x000000, secondary: Int = 0xffffff)
    {
        super();
        this.primary = primary.toHxdColor();
        this.secondary = secondary.toHxdColor();
        this.outline = MainLoop.instance.CLEAR_COLOR.toHxdColor();
        this.background = MainLoop.instance.CLEAR_COLOR.toHxdColor();
        this.clearBackground = 1;
    }
}
