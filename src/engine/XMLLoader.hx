package engine;

typedef XMLData = {}

@:generic
class XMLLoader<T: XMLData> {
	private var xmlPath: String;
	private var xmlData: Map<String, Xml>;

	public function new(path: String) {
		xmlPath = path;
		xmlData = new Map();
	}

	public function load(name: String) {
		var xmlRes = hxd.Res.loader.load('${xmlPath}/${name}.xml');
		var xmlText = xmlRes.toText();
		var xml = Xml.parse(xmlText);

		for (child in xml.firstElement().elements()) {
			var objName = child.get("name");
			xmlData.set(objName, child);
		}
	}

	public function parse(name: String): Null<T> {
		return null;
	}
}
