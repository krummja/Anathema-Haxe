package engine;

import hxd.Pixels;

class ColorPaletteResources {
	public static var palettes: Map<ColorPaletteKey, ColorPalette> = [];

	public static function get(key: ColorPaletteKey): ColorPalette {
		if (key == null) return null;
		var palette = palettes.get(key);
		if (palette == null) return null;
		return palette;
	}

	public static function init(): Void {
		var anathema = hxd.Res.tiles.palettes.anathema.getPixels(RGBA);
		palettes.set(PALETTE_ANATHEMA, parse(anathema));
		trace("ColorPaletteResources initialized");
	}

	private static function parse(image: Pixels): ColorPalette {
		var p = new ColorPalette();

		p.setColor(C_WHITE, image.getPixel(0, 0));
		p.setColor(C_GRAY_1, image.getPixel(1, 0));
		p.setColor(C_GRAY_2, image.getPixel(2, 0));
		p.setColor(C_GRAY_3, image.getPixel(3, 0));
		p.setColor(C_GRAY_4, image.getPixel(4, 0));
		p.setColor(C_GRAY_5, image.getPixel(5, 0));
		p.setColor(C_GRAY_6, image.getPixel(6, 0));
		p.setColor(C_BLACK, image.getPixel(7, 0));

		p.setColor(C_GREEN_0, image.getPixel(0, 1));
		p.setColor(C_GREEN_1, image.getPixel(1, 1));
		p.setColor(C_GREEN_2, image.getPixel(2, 1));
		p.setColor(C_GREEN_3, image.getPixel(3, 1));
		p.setColor(C_GREEN_4, image.getPixel(4, 1));
		p.setColor(C_GREEN_5, image.getPixel(5, 1));
		p.setColor(C_RESERVE_0, image.getPixel(6, 1));
		p.setColor(C_RESERVE_1, image.getPixel(7, 1));

		p.setColor(C_BLUE_0, image.getPixel(0, 2));
		p.setColor(C_BLUE_1, image.getPixel(1, 2));
		p.setColor(C_BLUE_2, image.getPixel(2, 2));
		p.setColor(C_BLUE_3, image.getPixel(3, 2));
		p.setColor(C_BLUE_4, image.getPixel(4, 2));
		p.setColor(C_BLUE_5, image.getPixel(5, 2));
		p.setColor(C_RESERVE_2, image.getPixel(6, 2));
		p.setColor(C_RESERVE_3, image.getPixel(7, 2));

		p.setColor(C_PURPLE_0, image.getPixel(0, 3));
		p.setColor(C_PURPLE_1, image.getPixel(1, 3));
		p.setColor(C_PURPLE_2, image.getPixel(2, 3));
		p.setColor(C_PURPLE_3, image.getPixel(3, 3));
		p.setColor(C_PURPLE_4, image.getPixel(4, 3));
		p.setColor(C_PURPLE_5, image.getPixel(5, 3));
		p.setColor(C_RESERVE_4, image.getPixel(6, 3));
		p.setColor(C_RESERVE_5, image.getPixel(7, 3));

		p.setColor(C_YELLOW_0, image.getPixel(0, 4));
		p.setColor(C_YELLOW_1, image.getPixel(1, 4));
		p.setColor(C_YELLOW_2, image.getPixel(2, 4));
		p.setColor(C_YELLOW_3, image.getPixel(3, 4));
		p.setColor(C_YELLOW_4, image.getPixel(4, 4));
		p.setColor(C_YELLOW_5, image.getPixel(5, 4));
		p.setColor(C_RESERVE_6, image.getPixel(6, 4));
		p.setColor(C_FIRE_LIGHT, image.getPixel(7, 4));

		p.setColor(C_RED_0, image.getPixel(0, 5));
		p.setColor(C_RED_1, image.getPixel(1, 5));
		p.setColor(C_RED_2, image.getPixel(2, 5));
		p.setColor(C_RED_3, image.getPixel(3, 5));
		p.setColor(C_RED_4, image.getPixel(4, 5));
		p.setColor(C_RED_5, image.getPixel(5, 5));
		p.setColor(C_RESERVE_7, image.getPixel(6, 5));
		p.setColor(C_RESERVE_8, image.getPixel(7, 5));

		p.setColor(C_RESERVE_9, image.getPixel(0, 6));
		p.setColor(C_RESERVE_10, image.getPixel(1, 6));
		p.setColor(C_RESERVE_11, image.getPixel(2, 6));
		p.setColor(C_RESERVE_12, image.getPixel(3, 6));
		p.setColor(C_RESERVE_13, image.getPixel(4, 6));
		p.setColor(C_RESERVE_14, image.getPixel(5, 6));
		p.setColor(C_RESERVE_15, image.getPixel(6, 6));
		p.setColor(C_RESERVE_16, image.getPixel(7, 6));

		// Special colors
		p.setColor(C_SHROUD, image.getPixel(0, 7));
		p.setColor(C_RESERVE_17, image.getPixel(1, 7));
		p.setColor(C_RESERVE_18, image.getPixel(2, 7));
		p.setColor(C_RESERVE_19, image.getPixel(3, 7));
		p.setColor(C_RESERVE_20, image.getPixel(4, 7));
		p.setColor(C_RESERVE_21, image.getPixel(5, 7));
		p.setColor(C_BRIGHT_WHITE, image.getPixel(6, 7));
		p.setColor(C_CLEAR, image.getPixel(7, 7));

		return p;
	}
}
