package engine;

typedef XmlData = {}

@:generic
class XmlLoader<T: XmlData> {
	private var xmlPath: String;
	private var xmlData: Map<String, Xml>;

	public function new(path: String) {
		xmlPath = path;
		xmlData = new Map();
	}

	public function load(name: String) {
		trace('Loading ${name}.xml');
		var xmlRes = hxd.Res.loader.load('${xmlPath}/${name}.xml');
		var xmlText = xmlRes.toText();
		var xml = Xml.parse(xmlText);

		for (child in xml.firstElement().elements()) {
			var objName = child.get("name");
			xmlData.set(objName, child);
		}
	}

	private function parse(name: String): Null<T> {
		return null;
	}
}
