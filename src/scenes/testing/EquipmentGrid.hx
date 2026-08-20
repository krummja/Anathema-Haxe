package scenes.testing;

import common.struct.Grid;
import haxe.ui.containers.Box;
import haxe.ui.containers.VBox;

typedef EquipmentSlot = {
	var id: String;
	var active: Bool;
}

@:xml('
    <vbox id="equipmentGrid">
    </vbox>
')
class EquipmentGrid extends VBox {
	private var slots: Grid<EquipmentSlot>;

	public function new(width: Int, height: Int) {
		super();
		slots = new Grid(width, height);
	}

	public function redraw() {}
}
