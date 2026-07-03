package domain.components;

import data.Bitmasks;
import data.Bitmasks.BitmaskData;
import ecs.Component;
import data.BitmaskType;

class BitmaskSprite extends Component {
	public var bitmaskTypes: Array<BitmaskType>;
	public var overwriteTile: Bool;

	public var bitmaskType(get, never): BitmaskType;
	public var bitmask(get, never): BitmaskData;

	public function new(bitmaskTypes: Array<BitmaskType>, overwriteTile: Bool = true) {
		this.bitmaskTypes = bitmaskTypes;
		this.overwriteTile = overwriteTile;
	}

	private inline function get_bitmask(): BitmaskData {
		return Bitmasks.get(bitmaskType);
	}

	private inline function get_bitmaskType(): BitmaskType {
		return bitmaskTypes[0];
	}
}
