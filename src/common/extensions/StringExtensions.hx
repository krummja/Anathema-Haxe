package common.extensions;

class StringExtensions {
	public static inline function lpad(s: String, length: Int, ?ch: String = ' '): String {
		return StringTools.lpad(s, ch, length);
	}
}
