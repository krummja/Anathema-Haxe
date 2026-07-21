package scenes.ui;

import haxe.ui.core.Component;

class ComponentPathUtils {
	public static function getComponentPath(comp: Component): String {
		var path: Array<String> = [];
		var current: Component = comp;

		while (current != null) {
			var identifier = "";
			if (current.id != null && current.id != "") {
				identifier = "#" + current.id;
			} else if (current.styleNames != null && current.styleNames != "") {
				identifier = "." + current.styleNames.split(" ").join(".");
			} else {
				identifier = Std.string(Type.getClassName(Type.getClass(current)));
			}

			path.unshift(identifier);
			current = current.parentComponent;
		}

		return path.join(" > ");
	}
}
