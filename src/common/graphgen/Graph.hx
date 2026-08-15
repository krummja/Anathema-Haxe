package common.graphgen;

import common.graphgen.Node.NodeData;
import common.util.FS;
import haxe.extern.EitherType;
import sys.io.File;
import utest.Assert;
import utest.Test;

@:generic
class Graph<T: NodeData> {
	public var nodeCount(get, never): Int;
	public var edgeCount(get, never): Int;
	public var labels(get, never): Array<String>;
	public var names(get, never): Array<String>;

	public var nodes(default, null): Map<String, Node<T>>;
	public var neighbors(default, null): Map<String, Array<Node<T>>>;

	private var edges: Map<String, Array<Node<T>>>;

	public function new() {
		this.nodes = new Map();
		this.edges = new Map();
		this.neighbors = new Map();
	}

	public function join(graph: Graph<T>, targetUid: String): Graph<T> {
		var mergedGraph = new Graph<T>();

		var seenNames = new Map<String, Int>();
		var keyTrack = new Map<String, String>();
		var edgeTrack = new Map<String, Array<Node<T>>>();

		for (node in nodes) {
			var label = node.label;

			if (seenNames.exists(label)) {
				var count = seenNames.get(label);
				seenNames.set(label, count + 1);
			} else {
				seenNames.set(label, 0);
			}
		}

		for (node in graph.nodes) {
			var label = node.label;

			if (seenNames.exists(label)) {
				var count = seenNames.get(label);
				seenNames.set(label, count + 1);
				keyTrack.set(node.uid, '${label}_${count + 1}');
			} else {
				seenNames.set(label, 0);
				keyTrack.set(node.uid, node.uid);
			}
		}

		for (node in nodes) {
			mergedGraph.addNode(node);
		}

		for (node in graph.nodes) {
			var newUid = keyTrack.get(node.uid);
			var newNumber = Std.parseInt(newUid.split("_")[1]);

			var newNode = new Node(
				newUid,
				node.data,
				node.label,
				newNumber,
			);

			mergedGraph.addNode(newNode);
		}

		for (key => edgeNodes in edges) {
			var n = mergedGraph.nodes.get(key);

			for (node in edgeNodes) {
				var m = mergedGraph.nodes.get(node.uid);

				if (n.uid == m.uid) {
					continue;
				}

				mergedGraph.addEdge(n, m);
			}
		}

		for (key => edgeNodes in graph.edges) {
			var n = mergedGraph.nodes.get(keyTrack.get(key));

			if (StringTools.contains(n.uid, "root")) {
				var targetNode = mergedGraph.nodes.get(targetUid);
				mergedGraph.addEdge(targetNode, n);
			}

			for (node in edgeNodes) {
				var m = mergedGraph.nodes.get(keyTrack.get(node.uid));

				if (
					n != null &&
					m != null &&
					n.uid != m.uid
				) {
					mergedGraph.addEdge(n, m);
				}
			}
		}

		return mergedGraph;
	}

	public function addNode(node: Node<T>): Node<T> {
		if (!nodes.exists(node.uid)) {
			nodes.set(node.uid, node);
			edges.set(node.uid, []);
			neighbors.set(node.uid, []);
		}

		return node;
	}

	public inline overload extern function addEdge(n: Node<T>, m: Node<T>) {
		if (!nodes.exists(n.uid)) {
			addNode(n);
		}

		if (!nodes.exists(m.uid)) {
			addNode(m);
		}

		edges[n.uid].push(m);
		neighbors[n.uid].push(m);
		neighbors[m.uid].push(n);
	}

	public function removeNode(uid: String): Bool {
		if (!nodes.exists(uid)) {
			return false;
		}

		for (endNode in edges[uid]) {
			removeEdge(uid, endNode.uid);
		}

		for (startUid => _ in nodes) {
			removeEdge(startUid, uid);
		}

		edges.remove(uid);

		for (otherUid => _ in neighbors) {
			neighbors[otherUid].findRemove((node) -> node.uid == uid);
		}

		neighbors.remove(uid);

		return nodes.remove(uid);
	}

	public function removeEdge(startUid: String, endUid: String): Bool {
		if (
			!nodes.exists(startUid) ||
			!nodes.exists(endUid)
		) {
			return false;
		}

		var startNode = nodes[startUid];
		var endNode = nodes[endUid];

		if (!edges[startUid].contains(endNode)) {
			return false;
		}

		edges[startUid].remove(endNode);
		neighbors[startUid].remove(endNode);
		neighbors[endUid].remove(startNode);

		startNode.degree -= 1;
		endNode.degree -= 1;

		return true;
	}

	public function hasAdjacentNodes(startUid: String, endUid: String): Bool {
		if (
			!nodes.exists(startUid) ||
			!nodes.exists(endUid)
		) {
			return false;
		}

		var endNode = nodes[endUid];
		return edges[startUid].contains(endNode);
	}

	public function toPlantUML(fileName: String): Void {
		var puml = '@startuml\n\n';
		puml += 'hide empty members\n';
		for (node in nodes) {
			puml += node.toPlantUML() + '\n';
		}

		for (node => edgeList in edges) {
			for (item in edgeList) {
				if (node == item.uid) {
					continue;
				}

				puml += '${node} -- ${item.uid}\n';
			}
		}

		puml += '\n@enduml';

		File.saveContent(FS.filePath(["graphs", fileName + ".puml"]), puml);
	}

	private function get_nodeCount(): Int {
		return Lambda.count(nodes);
	}

	private function get_edgeCount(): Int {
		return Lambda.count(edges);
	}

	private function get_labels(): Array<String> {
		return [for (node in nodes) node.label];
	}

	private function get_names(): Array<String> {
		return [for (node in nodes) node.name];
	}
}

typedef TestData = {
	> NodeData,
	public var foo: String;
	public var bar: Int;
}

class TestGraph1 extends Test {
	private var graph: Graph<TestData>;

	public function setup() {
		graph = new Graph<TestData>();

		var d1: TestData = {foo: "n1-data", bar: 1};
		var d2: TestData = {foo: "n2-data", bar: 2};
		var n1 = graph.addNode(new Node("n1", d1));
		var n2 = graph.addNode(new Node("n2", d2));
		graph.addEdge(n1, n2);
	}

	public function testHasNodes() {
		Assert.isTrue(graph.nodes.exists("n1"));
		Assert.isTrue(graph.nodes.exists("n2"));
		Assert.isFalse(graph.nodes.exists("n3"));
	}

	public function testHasEdges() {
		Assert.equals(2, graph.edgeCount);
		Assert.equals(2, graph.nodeCount);
	}
}
