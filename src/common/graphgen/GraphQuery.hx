package common.graphgen;

import common.graphgen.Node.NodeData;
import utest.Assert;
import utest.Test;

/**
 * Processor for matching subgraphs of graphs.
 * Lee et al. (2013) An In-depth Comparison of Subgraph Isomorphism
 * Algorithms in Graph Databases. In Proceedings of the VLDB Endowment,
 * Vol. 6, No. 2.
 * http://www.vldb.org/pvldb/vol6/p133-han.pdf
 *
 * Input:   query graph
 * Input:   data graph
 * Output:  all subgraph isomorphsms of q in g
 */
@:generic
class GraphQuery<T: NodeData> {
	private var dataGraph: Graph<T>;
	private var solutions: Array<Map<String, Node<T>>>;
	private var matchHistory: Array<Map<String, Node<T>>>;

	public function new(dataGraph: Graph<T>) {
		this.dataGraph = dataGraph;
		solutions = [];
		matchHistory = [];
	}

	public function search(queryGraph: Graph<T>): Array<Map<String, Node<T>>> {
		var matches = new Map();
		solutions = [];

		if (findCandidates(queryGraph)) {
			subgraphSearch(matches, queryGraph);
		}

		return solutions;
	}

	public function filterCandidates(queryNode: Node<T>): Array<Node<T>> {
		return dataGraph.nodes.filter((node) -> node.label == queryNode.label);
	}

	public function findCandidates(queryGraph: Graph<T>): Bool {
		if (
			dataGraph.nodeCount == 0 ||
			queryGraph.nodeCount == 0
		) {
			return false;
		}

		for (node in queryGraph.nodes) {
			node.candidates = filterCandidates(node);

			if (node.candidates.length == 0) {
				return false;
			}

			// var candidateString = "";
			// for (candidate in node.candidates) {
			// 	candidateString += candidate.toString();
			// }
		}

		return true;
	}

	public function findMatchedNeighbors(queryNode: Node<T>, matches: Map<String,
		Node<T>>): Map<String, Node<T>> {
		var result = new Map();

		if (Lambda.count(matches) == 0) {
			return result;
		}

		for (node in dataGraph.neighbors[queryNode.uid]) {
			if (matches.exists(node.uid)) {
				result[node.uid] = node;
			}
		}

		return result;
	}

	public function isMatchable(queryNode: Node<T>, dataNode: Node<T>, queryGraph: Graph<T>, matches: Map<String,
		Node<T>>): Bool {
		if (Lambda.count(matches) == 0) {
			return true;
		}

		var neighbors = findMatchedNeighbors(queryNode, matches);

		for (n in neighbors) {
			var match = matches[n.uid];
			var m = dataGraph.nodes[match.uid];

			if (
				queryGraph.hasAdjacentNodes(queryNode.uid, n.uid) &&
				queryGraph.hasAdjacentNodes(dataNode.uid, m.uid)
			) {
				return true;
			} else if (
				queryGraph.hasAdjacentNodes(n.uid, queryNode.uid) &&
				queryGraph.hasAdjacentNodes(m.uid, dataNode.uid)
			) {
				return true;
			}
		}

		return false;
	}

	public function nextUnmatchedNode(matches: Map<String, Node<T>>): Null<Node<T>> {
		for (node in dataGraph.nodes) {
			if (!matches.exists(node.uid)) {
				return node;
			}
		}

		return null;
	}

	public function refineCandidates(candidates: Array<Node<T>>, queryNode: Node<T>, matches: Map<String,
		Node<T>>): Array<Node<T>> {
		var newCandidates = [];

		for (candidate in candidates) {
			if (
				candidate.degree >= queryNode.degree &&
				!matches.exists(candidate.uid)
			) {
				newCandidates.push(candidate);
			}
		}

		return newCandidates;
	}

	private function subgraphSearch(matches: Map<String,
		Node<T>>, queryGraph: Graph<T>): Void {
		// If all nodes have been matched, we're done. Store the solution and return.
		if (Lambda.count(matches) == queryGraph.nodeCount) {
			solutions.push(matches);
			return;
		}

		// Get the next query node that needs a match
		var queryNode = nextUnmatchedNode(matches);
		var candidateString = "";
		for (dataNode in queryNode.candidates) {
			candidateString += dataNode.toString() + " ";
		}

		// Save the current candidate list of queryNode so we can restore them after we've
		// exhausted existing mappings.
		var oldCandidates = queryNode.candidates;

		// Refine the list of candidate nodes from those obviously not good
		queryNode.candidates = refineCandidates(queryNode.candidates, queryNode, matches);

		var candidateString = "";
		for (dataNode in queryNode.candidates) {
			candidateString += dataNode.toString() + " ";
		}

		// Check each candidate for possible match
		for (dataNode in queryNode.candidates) {
			// Check to see if the queryNode and dataNode are matchable in the data graph
			if (isMatchable(queryNode, dataNode, queryGraph, matches)) {
				// They are - store the mapping and continue
				updateState(queryNode, dataNode, matches);

				// Search the subgraph
				subgraphSearch(matches, queryGraph);

				// Undo the last mapping
				matches = restoreState();
			}
		}

		queryNode.candidates = oldCandidates;
	}

	private function restoreState() {
		return matchHistory.pop();
	}

	private function updateState(
		queryNode: Node<T>,
		dataNode: Node<T>,
		matches: Map<String, Node<T>>
	): Void {
		matches[queryNode.uid] = dataNode;
		matchHistory.push(matches);
	}
}

typedef TestData2 = {
	> NodeData,
	var foo: String;
}

class TestGraph2 extends Test {
	var dataGraph: Graph<TestData2>;

	public function setup() {
		dataGraph = new Graph<TestData2>();

		var n1 = dataGraph.addNode(new Node("n1", cast {foo: "foo"}));
		var n2 = dataGraph.addNode(new Node("n2", cast {foo: "foo2"}));
		var n3 = dataGraph.addNode(new Node("n3", cast {foo: "foo3"}));
		dataGraph.addEdge(n1, n2);
		dataGraph.addEdge(n2, n3);
	}

	public function testNodeCount() {
		Assert.equals(3, dataGraph.nodeCount);
	}

	public function testQuery() {
		var qGraph = new Graph<TestData2>();
		var n1 = qGraph.addNode(new Node("n1", cast {foo: "foo"}));
		var n2 = qGraph.addNode(new Node("n2", cast {foo: "foo2"}));
		qGraph.addEdge(n1, n2);

		var query = new GraphQuery<TestData2>(dataGraph);
		var solutions = query.search(qGraph);
		Assert.isTrue(solutions.length > 0);
	}
}
