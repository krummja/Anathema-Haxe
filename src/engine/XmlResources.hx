package engine;

import common.graphgen.Graph;
import common.graphgen.Node;

typedef Structure = {
	var name: String;
	var margin: Int;
	var material: String;
	var width: Int;
	var height: Int;
}

typedef ModelNode = {
	var id: String;
	var parent: String;
	var xml: Xml;
	var level: Int;
}

class XmlWalker {
	public var nodes(default, null): Array<ModelNode>;

	private var seenNames = new Map<String, Int>();

	public function new() {
		nodes = new Array();
		seenNames = new Map();
	}

	public function walk(xml: Xml, parentId: Null<String> = null, level: Int = 0): Void {
		if (xml.nodeType == Xml.Element) {
			var seenKeys = seenNames.keys().toArray();
			if (seenKeys.has(xml.nodeName)) {
				var value = seenNames.get(xml.nodeName);
				seenNames.set(xml.nodeName, value + 1);
			} else {
				seenNames.set(xml.nodeName, 0);
			}

			var nodeId = xml.nodeName.toLowerCase()
				+ "_"
				+ Std.string(seenNames.get(xml.nodeName));

			var node = {
				id: nodeId,
				parent: parentId == null ? nodeId : parentId,
				xml: xml,
				level: level,
			};

			nodes.push(node);
			level++;

			for (child in xml.elements()) {
				walk(child, node.id, level);
			}
		}
	}
}

class XmlGraph {
	public var definitions(get, never): Iterator<haxe.xml.Access>;

	public var structures(default, null): Array<Structure>;
	public var graph(default, null): Graph<ModelNode>;

	private var xml: Xml;
	private var access: haxe.xml.Access;

	public function new(xml: Xml) {
		this.xml = xml;
		structures = new Array();

		var template = this.xml.firstElement();
		access = new haxe.xml.Access(template);

		graph = new Graph();

		parseStructures();
		parseModel();
	}

	/**
	 * Parse all `<Structure>` nodes in the XML tree.
	 *
	 *
	 * ## Example
	 *
	 * ```xml
	 * <Structure
	 *    name="Tree"
	 *    width="2"
	 *    width="2"
	 *    margin="2"
	 *    material="forest"
	 * />
	 * ```
	 *
	 * The XML element is parsed to a `Structure` type:
	 *
	 * ```haxe
	 * {
	 *    name: "Tree",
	 *    width: 2,
	 *    height: 2,
	 *    margin: 2,
	 *    material: "forest"
	 * }
	 * ```
	 *
	 * A structure without width and height is a container node and may have any number
	 * of container or non-container nodes inside of it.
	 */
	private function parseStructures() {
		for (definition in definitions) {
			var width = "-1";
			var height = "-1";

			if (definition.has.width) {
				width = definition.att.width;
			}

			if (definition.has.height) {
				height = definition.att.height;
			}

			var structure: Structure = {
				name: definition.att.name,
				margin: Std.parseInt(definition.att.margin),
				material: definition.att.material,
				width: Std.parseInt(width),
				height: Std.parseInt(height)
			};

			structures.push(structure);
		}
	}

	private function parseModel() {
		var template = xml.firstElement();
		var root = template.elementsNamed("Root").toArray();

		var walker = new XmlWalker();

		walker.walk(root.pop());

		for (nodeDatum in walker.nodes) {
			var nameParts = nodeDatum.id.split("_");

			var node = new Node(
				nodeDatum.id,
				nodeDatum,
				nameParts[0],
				Std.parseInt(nameParts[1]),
			);

			graph.addNode(node);
		}

		for (_ => node in graph.nodes) {
			var n = graph.nodes.get(node.data.parent);
			var m = graph.nodes.get(node.data.id);
			graph.addEdge(n, m);
		}
	}

	private function validateModel() {
		var validTags = [];

		for (definition in definitions) {
			validTags.push(definition.att.name);
		}
	}

	private function get_definitions(): Iterator<haxe.xml.Access> {
		return access.node.Structures.elements;
	}
}

class XmlResources {
	public static var xmlGraphs: Map<XmlKey, XmlGraph> = [];

	public static function get(key: XmlKey): XmlGraph {
		return xmlGraphs.get(key);
	}

	public static function init() {
		loadXml(Test);
		loadXml(Test2);
	}

	private static function loadXml(key: XmlKey) {
		var xmlName = Std.string(key).toLowerCase();
		var xmlRes = hxd.Res.loader.load('xml/${xmlName}.xml');
		var xmlText = xmlRes.toText();
		var xml = Xml.parse(xmlText);
		xmlGraphs.set(key, new XmlGraph(xml));
	}
}
