package uilib;

import engine.ColorKey;
import haxe.ui.containers.Box;
import haxe.ui.containers.HBox;
import haxe.ui.containers.ScrollView;
import haxe.ui.containers.VBox;
import uilib.SLabel;

typedef Segment = {
	var text: String;
	var isPunctuation: Bool;
	var ?color: String;
	var ?style: String;
}

class TagParser {
	private var text: String;
	private var startTag = ~/<(\w*)>/;
	private var endTag = ~/<\/(\w*)>/;
	private var punctuation = ~/[.?!'";:]/;

	public function new(text: String) {
		this.text = text;
	}

	public function parse(): Array<Segment> {
		var results: Array<Segment> = [];
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

				var isPunctuation = false;

				if (punctuation.match(strElem) && strElem != "::") {
					isPunctuation = true;
				}

				results.push({
					text: strElem,
					isPunctuation: isPunctuation,
					color: color,
				});
			}
		}

		return results;
	}
}

class LogLine extends HBox {
	private var defaultColor: Int;

	public function new(segments: Array<Segment>, padding: Int = 4, width: Int = 400, defaultColor: Int = 0xffffff) {
		super();

		this.defaultColor = defaultColor;
		continuous = true;
		this.customStyle = {
			width: width - 2 - (padding * 2),
			horizontalSpacing: 0,
		};

		for (segment in segments) {
			var colorInt = parseColor(segment.color);
			var word = new SLabel(segment.text, colorInt);
			if (!segment.isPunctuation) {
				word.paddingLeft = 4;
			}
			addComponent(word);
		}
	}

	private function parseColor(colorName: String): Int {
		return switch (colorName) {
			case "red":
				C_RED_HC.toInt();
			case "green":
				C_GREEN_HC.toInt();
			case "blue":
				C_BLUE_HC.toInt();
			case "purple":
				C_PURPLE_1.toInt();
			case "yellow":
				C_YELLOW_HC.toInt();
			case _:
				this.defaultColor;
		}
	}
}

@:xml('
	<scrollview id="logScroller" styleName="log-scroller">
		<vbox id="log" styleName="log" />
	</scrollview>
')
class LogPanel extends ScrollView {
	public var scrollviewContents(get, never): Box;

	private var contentPadding: Int;

	public function new(width: Int, height: Int, padding: Int = 4) {
		super();

		this.width = width;
		this.height = height;
		this.contentPadding = padding;
		scrollviewContents.customStyle = {
			padding: padding,
		};
	}

	public function addLogline(text: String): Void {
		var parser = new TagParser(text);
		var segments = parser.parse();
		var line = new LogLine(segments, this.contentPadding);
		log.addComponent(line);
	}

	private function get_scrollviewContents(): Box {
		return cast log.parentComponent;
	}
}
