package shaders;

class SpriteShader extends hxsl.Shader {
    // @formatter:off
    private static var SRC = {
        var pixelColor: Vec4;

        @param var primary: Vec3;
		@param var secondary: Vec3;
		@param var outline: Vec3;
		@param var background: Vec3;
        @param var clearBackground: Int;

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

            if (isPrimary) {
                color = primary;
            }

            else if (isSecondary) {
                color = secondary;
            }

            else if (isOutline) {
                color = outline;
            }

            // Source pixel is magenta
            if (color.r == 1.0 && color.g == 0.0 && color.b == 1.0) {
                color = background;
                alpha = 1;
            }

            pixelColor.rgb = color;
            pixelColor.a = alpha;
        }
    };

    public function new(
        primary: Int = 0x000000,
        secondary: Int = 0xffffff,
        outline: Int = 0x000000,
        background: Int = 0xff00ff,
    ) {
        super();
		this.primary = primary.toHxdColor().toVector();
		this.secondary = secondary.toHxdColor().toVector();
		this.outline = outline.toHxdColor().toVector();
		this.background = background.toHxdColor().toVector();
        this.clearBackground = 1;
    }
    // @formatter:on
}
