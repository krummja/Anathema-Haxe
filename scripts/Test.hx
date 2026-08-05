function getMatches(ereg: EReg, input: String, index: Int = 0): Array<Dynamic> {
	var matches: Array<Dynamic> = [];
	while (ereg.match(input)) {
		matches.push([index, ereg.matched(index)]);
		input = ereg.matchedRight();
	}
	return matches;
}

class TagParser {
	private var text: String;
	private var startTag = ~/<(\w*)>/;
	private var endTag = ~/<\/(\w*)>/;

	public function new(text: String) {
		this.text = text;
	}

	public function parse() {
		var results = [];
		var root = '<root>${this.text}</root>';
		var xml = Xml.parse(root).firstElement();

		var parts = [];

		for (elem in xml) {
			var elements = elem.toString().split(" ");
			var color = "default";

			for (strElem in elements) {
				if (startTag.match(strElem)) {
					color = startTag.matched(1);
					strElem = startTag.replace(strElem, "");
				}

				if (endTag.match(strElem)) {
					strElem = endTag.replace(strElem, "");
				}

				if (strElem == "") {
					continue;
				}

				results.push({
					text: strElem,
					color: color,
				});
			}
		}

		return results;
	}
}

typedef Segment = {
	var text: String;
	var color: String;
}

class Test {
	public static var COLORMAP = ["red" => 0xff0000, "green" => 0x00ff00, "blue" => 0x0000ff,];

	public static function main(): Void {
		new Test();
	}

	public function new() {
		var text = "<red>Hello world</red>. <blue>This is some</blue> test <red>text</red>.";
		var parser = new TagParser(text);
		var segments = parser.parse();
	}
}
