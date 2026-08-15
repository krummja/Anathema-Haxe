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

	@:generic
	public static function merge<K, V>(
		mapA: Map<K, V>,
		mapB: Map<K, V>,
		keyFunction: (key: K) -> K
	): Map<K, V> {
		var result = new Map<K, V>();
		for (k => v in mapA) {
			result.set(k, v);
		}

		var mapAKeys = mapA.keys().toArray();

		for (k => v in mapB) {
			if (mapAKeys.contains(k)) {
				k = keyFunction(k);
			}

			result.set(k, v);
		}

		return result;
	}
}
