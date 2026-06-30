package common.struct;

@:generic class PriorityQueue<T> {
	public var isEmpty(get, never): Bool;

	public var length(get, never): Int;

	private var items: Array<{value: T, priority: Float}>;

	public function new() {
		this.items = new Array();
	}

	public function pop(): Null<T> {
		return isEmpty ? null : items.shift().value;
	}

	public function peek(): Null<T> {
		return isEmpty ? null : items[0].value;
	}

	public function put(value: T, priority: Float): Void {
		var item = {value: value, priority: priority};

		for (i in 0...length) {
			if (items[i].priority > item.priority) {
				items.insert(i, item);
				return;
			}
		}

		items.push(item);
	}

	private function get_isEmpty(): Bool {
		return items.length == 0;
	}

	private function get_length(): Int {
		return items.length;
	}
}
