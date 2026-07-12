package scenes.ui.listselect;

typedef SelectableListItem<T> = {
	var item: T;
	var idx: Int;
	var isSelected: Bool;
}

@:generic
class SelectableList<T> {
	private var items: Array<T>;
	private var maxLength: Null<Int>;
	private var idx: Int;

	public var isEmpty(get, never): Bool;
	public var length(get, never): Int;
	public var selected(get, never): T;
	public var data(get, never): Array<SelectableListItem<T>>;

	public function new(items: Array<T>, idx: Int = 0) {
		this.items = items;
		this.idx = idx;
	}

	public function setItems(values: Array<T>) {
		items = values;
		selectIdx(idx);
	}

	public function dequeue(): Null<T> {
		return items.shift();
	}

	public function selectIdx(value: Int) {
		idx = value.clamp(0, length - 1);
	}

	public function up() {
		idx--;

		if (idx < 0) {
			idx = items.length - 1;
		}
	}

	public function down() {
		idx++;

		if (idx >= items.length) {
			idx = 0;
		}
	}

	public function iterator(): Iterator<SelectableListItem<T>> {
		return data.iterator();
	}

	private function get_selected(): T {
		return items[idx];
	}

	private function get_length(): Int {
		return items.length;
	}

	private function get_isEmpty(): Bool {
		return items.length == 0;
	}

	private function get_data(): Array<SelectableListItem<T>> {
		var i = 0;
		return items.map((item: T) -> ({
			item: item,
			idx: i,
			isSelected: i++ == idx,
		}));
	}
}
