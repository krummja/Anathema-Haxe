package data;

import core.ColorPalette;
import hxd.Pixels;


class ColorPaletteResources
{
    public static var palettes: Map<ColorPaletteKey, core.ColorPalette> = [];

    public static function Get(key: ColorPaletteKey): core.ColorPalette
    {
        if (key.isNull()) return null;
        var palette = palettes.get(key);
        if (palette.isNull()) return null;
        return palette;
    }

    public static function Init(): Void
    {
        var anathema = hxd.Res.tiles.palettes.anathema.getPixels(BGRA);
        palettes.set(PALETTE_ANATHEMA, Parse(anathema));
    }

    private static function Parse(image: Pixels): ColorPalette
    {
        var p = new ColorPalette();

		p.setColor(C_WHITE, image.getPixel(0, 0));
		p.setColor(C_GRAY_1, image.getPixel(1, 0));
		p.setColor(C_GRAY_2, image.getPixel(2, 0));
		p.setColor(C_GRAY_3, image.getPixel(3, 0));
		p.setColor(C_GRAY_4, image.getPixel(4, 0));
		p.setColor(C_GRAY_5, image.getPixel(5, 0));
		p.setColor(C_GRAY_6, image.getPixel(6, 0));
		p.setColor(C_BLACK, image.getPixel(7, 0));
		p.setColor(C_CLEAR, image.getPixel(7, 1));

		p.setColor(C_GREEN_0, image.getPixel(0, 1));
		p.setColor(C_GREEN_1, image.getPixel(1, 1));
		p.setColor(C_GREEN_2, image.getPixel(2, 1));
		p.setColor(C_GREEN_3, image.getPixel(3, 1));
		p.setColor(C_GREEN_4, image.getPixel(4, 1));
		p.setColor(C_GREEN_5, image.getPixel(5, 1));

		p.setColor(C_BLUE_0, image.getPixel(0, 2));
		p.setColor(C_BLUE_1, image.getPixel(1, 2));
		p.setColor(C_BLUE_2, image.getPixel(2, 2));
		p.setColor(C_BLUE_3, image.getPixel(3, 2));
		p.setColor(C_BLUE_4, image.getPixel(4, 2));
		p.setColor(C_BLUE_5, image.getPixel(5, 2));

		p.setColor(C_PURPLE_0, image.getPixel(0, 3));
		p.setColor(C_PURPLE_1, image.getPixel(1, 3));
		p.setColor(C_PURPLE_2, image.getPixel(2, 3));
		p.setColor(C_PURPLE_3, image.getPixel(3, 3));
		p.setColor(C_PURPLE_4, image.getPixel(4, 3));
		p.setColor(C_PURPLE_5, image.getPixel(5, 3));

		p.setColor(C_YELLOW_0, image.getPixel(0, 4));
		p.setColor(C_YELLOW_1, image.getPixel(1, 4));
		p.setColor(C_YELLOW_2, image.getPixel(2, 4));
		p.setColor(C_YELLOW_3, image.getPixel(3, 4));
		p.setColor(C_YELLOW_4, image.getPixel(4, 4));
		p.setColor(C_YELLOW_5, image.getPixel(5, 4));

		p.setColor(C_RED_0, image.getPixel(0, 5));
		p.setColor(C_RED_1, image.getPixel(1, 5));
		p.setColor(C_RED_2, image.getPixel(2, 5));
		p.setColor(C_RED_3, image.getPixel(3, 5));
		p.setColor(C_RED_4, image.getPixel(4, 5));
		p.setColor(C_RED_5, image.getPixel(5, 5));

        return p;
    }
}
