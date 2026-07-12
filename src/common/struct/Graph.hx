package common.struct;

class Node {
	public var uid(default, null): String;
	public var label(default, null): String;
	public var number(default, null): Int;
	public var data(default, null): Map<String, Any>;
	public var name(get, never): String;

	private var degree: Int;
	private var candidates: Array<Node>;

	public function new(uid: String, ?label: String, ?number: Int, ?data: Map<String, Any>) {
		this.uid = uid;
		this.number = number;
		this.label = label;

		this.degree = 0;
		this.candidates = [];

		if (data == null) {
			this.data = new Map();
		} else {
			this.data = data;
		}
	}

	@:allow(common.struct.Graph)
	private function incrementDegree() {
		degree++;
	}

	@:allow(common.struct.Graph)
	private function decrementDegree() {
		degree--;
	}

	private function get_name(): String {
		if (label == null && number == null) {
			return '';
		}

		if (number == null) {
			return label;
		}

		if (label == null) {
			return number.toString();
		}

		return '$label, $number';
	}
}

class Graph {
	public var nodeCount(default, null): Int;
	public var edgeCount(default, null): Int;

	private var nodes: Map<String, Node>;
	private var edges: Map<String, Array<Node>>;
	private var neighbors: Map<String, Array<Node>>;

	public function new() {
		this.nodes = new Map();
		this.edges = new Map();
		this.neighbors = new Map();
	}

	public function addEdge(n: Node, m: Node) {
		addNode(n);
		addNode(m);

		edges.get(n.uid).push(m);
		neighbors.get(n.uid).push(m);
		neighbors.get(m.uid).push(n);

		n.incrementDegree();
		m.incrementDegree();
	}

	public function addNode(node: Node): Node {
		nodes.set(node.uid, node);
		edges.set(node.uid, new Array());
		neighbors.set(node.uid, new Array());
		nodeCount++;
		return node;
	}

	public function removeEdge(startUid: String, endUid: String): Bool {
		if (!nodes.exists(startUid) || !nodes.exists(endUid)) {
			return false;
		}

		var startNode = nodes.get(startUid);
		var endNode = nodes.get(endUid);

		if (!edges.get(startUid).contains(startNode)) {
			return false;
		}

		edges.get(startUid).remove(endNode);
		neighbors.get(startUid).remove(endNode);
		neighbors.get(endUid).remove(startNode);

		startNode.decrementDegree();
		endNode.decrementDegree();

		return true;
	}

	public function removeNode(uid: String): Null<Node> {
		if (!nodes.exists(uid)) {
			return null;
		}

		for (endNode in edges.get(uid)) {
			removeEdge(uid, endNode.uid);
		}

		for (startUid in nodes.keys()) {
			removeEdge(startUid, uid);
		}

		edges.remove(uid);

		var node = nodes.get(uid);

		for (n in neighbors.keys()) {
			if (neighbors.exists(n)) {
				neighbors.get(n).remove(node);
			}
		}

		neighbors.remove(uid);
		nodes.remove(uid);
		return node;
	}

	public function findNode(name: String): Null<Node> {
		for (node in nodes) {
			if (node.name == name) {
				return node;
			}
		}

		return null;
	}
}
