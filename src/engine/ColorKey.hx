package engine;

enum abstract ColorKey(String) to String from String {
	var C_WHITE = 'C_WHITE';
	var C_GRAY_1 = 'C_GRAY_1';
	var C_GRAY_2 = 'C_GRAY_2';
	var C_GRAY_3 = 'C_GRAY_3';
	var C_GRAY_4 = 'C_GRAY_4';
	var C_GRAY_5 = 'C_GRAY_5';
	var C_GRAY_6 = 'C_GRAY_6';
	var C_BLACK = 'C_BLACK';

	var C_GREEN_0 = 'C_GREEN_0';
	var C_GREEN_1 = 'C_GREEN_1';
	var C_GREEN_2 = 'C_GREEN_2';
	var C_GREEN_3 = 'C_GREEN_3';
	var C_GREEN_4 = 'C_GREEN_4';
	var C_GREEN_5 = 'C_GREEN_5';
	var C_RESERVE_0 = 'C_RESERVE_0';
	var C_RESERVE_1 = 'C_RESERVE_1';

	var C_BLUE_0 = 'C_BLUE_0';
	var C_BLUE_1 = 'C_BLUE_1';
	var C_BLUE_2 = 'C_BLUE_2';
	var C_BLUE_3 = 'C_BLUE_3';
	var C_BLUE_4 = 'C_BLUE_4';
	var C_BLUE_5 = 'C_BLUE_5';
	var C_RESERVE_2 = 'C_RESERVE_2';
	var C_RESERVE_3 = 'C_RESERVE_3';

	var C_PURPLE_0 = 'C_PURPLE_0';
	var C_PURPLE_1 = 'C_PURPLE_1';
	var C_PURPLE_2 = 'C_PURPLE_2';
	var C_PURPLE_3 = 'C_PURPLE_3';
	var C_PURPLE_4 = 'C_PURPLE_4';
	var C_PURPLE_5 = 'C_PURPLE_5';
	var C_RESERVE_4 = 'C_RESERVE_4';
	var C_RESERVE_5 = 'C_RESERVE_5';

	var C_YELLOW_0 = 'C_YELLOW_0';
	var C_YELLOW_1 = 'C_YELLOW_1';
	var C_YELLOW_2 = 'C_YELLOW_2';
	var C_YELLOW_3 = 'C_YELLOW_3';
	var C_YELLOW_4 = 'C_YELLOW_4';
	var C_YELLOW_5 = 'C_YELLOW_5';
	var C_RESERVE_6 = 'C_RESERVE_6';
	var C_FIRE_LIGHT = 'C_FIRE_LIGHT';

	var C_RED_0 = 'C_RED_0';
	var C_RED_1 = 'C_RED_1';
	var C_RED_2 = 'C_RED_2';
	var C_RED_3 = 'C_RED_3';
	var C_RED_4 = 'C_RED_4';
	var C_RED_5 = 'C_RED_5';
	var C_RESERVE_7 = 'C_RESERVE_7';
	var C_RESERVE_8 = 'C_RESERVE_8';

	var C_RESERVE_9 = 'C_RESERVE_9';
	var C_RESERVE_10 = 'C_RESERVE_10';
	var C_RESERVE_11 = 'C_RESERVE_11';
	var C_RESERVE_12 = 'C_RESERVE_12';
	var C_RESERVE_13 = 'C_RESERVE_13';
	var C_RESERVE_14 = 'C_RESERVE_14';
	var C_RESERVE_15 = 'C_RESERVE_15';
	var C_RESERVE_16 = 'C_RESERVE_16';

	var C_SHROUD = 'C_SHROUD';
	var C_RESERVE_17 = 'C_RESERVE_17';
	var C_RESERVE_18 = 'C_RESERVE_18';
	var C_RESERVE_19 = 'C_RESERVE_19';
	var C_RESERVE_20 = 'C_RESERVE_20';
	var C_RESERVE_21 = 'C_RESERVE_21';
	var C_BRIGHT_WHITE = 'C_BRIGHT_WHITE';
	var C_CLEAR = 'C_CLEAR';

	@:to
	public function toInt(): Int {
		return MainLoop.getInstance().palette.getColor(this);
	}

	public function toHxdColor(a: Float = 1): h3d.Vector4 {
		return MainLoop.getInstance().palette.getColor(this).toHxdColor(a);
	}
}
