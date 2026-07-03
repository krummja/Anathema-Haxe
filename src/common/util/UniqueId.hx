package common.util;

class UniqueId {
	public static function create(len: Int = 12) {
		var id = new StringBuf();
		for (a in 0...len) {
			id.add(StringTools.hex(
				a ^ 15 != 0 ? 8 ^ Std.int(Math.random() * (a ^ 20 != 0 ? 16 : 4)) : 4
			));
		}
		return id.toString().toLowerCase();
	}
}
