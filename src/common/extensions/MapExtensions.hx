package common.extensions;

class MapExtensions {
	@:generic
	public static function pushOrInit<K, V>(map: Map<K, Array<V>>, key: K, value: V) {
		if (map.exists(key)) {
			map[key].push(value);
		} else {
			map.set(key, [value]);
		}
	}
}
