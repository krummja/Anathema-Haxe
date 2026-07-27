package common.struct;

import hxd.Rand;

typedef WeightedTableRow<T> = {
	var weight: Int;
	var value: T;
}

enum TableCombineMethod {
	Max;
	Min;
	Sum;
	Overwrite;
	Existing;
}

class WeightedTable<T> {
	private static function combine<V>(tables: Array<WeightedTable<V>>, method: TableCombineMethod = Sum): WeightedTable<V> {
		var table = new WeightedTable<V>();

		for (t in tables) {
			for (row in t.rows) {
				table.add(row.value, row.weight, method);
			}
		}

		return table;
	}

	private var rows: Array<WeightedTableRow<T>> = [];
	private var sum(get, never): Int;

	public function new() {}

	public function pick(r: Rand): Null<T> {
		var n = r.random(sum);
		var currentW = 0;

		var picked = rows.find((row) -> {
			currentW += row.weight;
			return currentW > n;
		});

		if (picked != null) {
			return picked.value;
		}

		return null;
	}

	public function reset() {
		rows = [];
	}

	public function get(value: T): Null<WeightedTableRow<T>> {
		return rows.find((row) -> row.value == value);
	}

	public function add(value: T, weight: Int, method: TableCombineMethod = Max) {
		var row = get(value);

		if (row == null) {
			rows.push({
				weight: weight,
				value: value,
			});
		} else {
			row.weight = switch method {
				case Max: Math.max(row.weight, weight).floor();
				case Min: Math.min(row.weight, weight).floor();
				case Sum: row.weight + weight;
				case Overwrite: weight;
				case Existing: row.weight;
			}
		}
	}

	public function remove(value: T): Bool {
		return rows.findRemove((row) -> row.value == value);
	}

	public function chance(value: T): Float {
		var row = get(value);

		if (row == null) {
			return 0;
		}

		return row.weight / sum;
	}

	private inline function get_sum(): Int {
		return rows.sum((row) -> row.weight).floor();
	}
}
