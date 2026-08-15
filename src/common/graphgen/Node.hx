package common.graphgen;

typedef NodeData = {}

@:generic
class Node<T: NodeData> {
	public var uid: String;
	public var label: Null<String>;
	public var number: Null<Int>;

	public var name(get, never): String;

	public var data(default, null): T;

	@:allow(common.graphgen.Graph)
	@:allow(common.graphgen.GraphQuery)
	private var degree: Int;

	@:allow(common.graphgen.GraphQuery)
	private var candidates: Array<Node<T>>;

	public function new(uid: String, ?data: T, ?label: Null<String>, ?number: Null<Int>) {
		this.uid = uid;
		this.label = label;
		this.number = number;

		this.data = data;
		this.degree = 0;
		this.candidates = [];
	}

	public function toPlantUML(): String {
		return 'object "${label} ${this.number}" as ${uid}';
	}

	public function toString(): String {
		var n = '${number.or(-1)}';
		return '${uid}, ${label}${n}';
	}

	private function get_name(): String {
		return makeName(label, number);
	}

	private function makeName(?label: String, ?number: Int): String {
		if (
			label == null &&
			number == null
		) {
			return "";
		} else if (number == null) {
			return label;
		} else if (label == null) {
			return Std.string(number);
		}

		return '${label}, ${number}';
	}
}
