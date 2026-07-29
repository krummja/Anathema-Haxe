package domain;

class GameMath {
	public static var XP_REQ_CAP = 4000;
	public static var XP_LVL_INTENSITY = 10;
	public static var XP_BASE_GAIN = 120;
	public static var XP_SPREAD = 8;
	public static var XP_POWER = 3;

	public static function getAttributePointTotal(level: Int): Int {
		return 7 + level;
	}

	public static function getMoveCost(speedStat: Int): Int {
		return 100 - (speedStat * 2);
	}
}
