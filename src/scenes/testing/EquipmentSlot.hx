package scenes.testing;

import haxe.ui.containers.Box;

class EquipmentSlot {
	public function new() {}
}

@:xml('
    <box>
        <vbox id="slot">
            <box id="slotGraphic">
            </box>
            <slabel id="slotText" />
        </vbox>
    </box>
')
class EquipmentSlotView extends Box {
	public function new() {
		super();

		slotGraphic.customStyle = {
			borderStyle: "solid",
			borderColor: 0xff0000,
			borderSize: 1,
		};
	}

	public function setId(x: Int, y: Int) {
		id = 'slot-${x}-${y}';
	}

	public function setSlotText(value: String): Void {
		slotText.text = value;
	}
}
