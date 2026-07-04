package domain.components;

import ecs.Component;

class Moniker extends Component {
	public var baseName: String;

	public var displayName(get, never): String;

	public function new(baseName: String) {
		this.baseName = baseName;
	}

	private function get_displayName(): String {
		var name = baseName;

		return name;
	}
}
