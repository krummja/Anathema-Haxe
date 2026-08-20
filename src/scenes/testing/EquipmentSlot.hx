package scenes.testing;

import engine.EventBus;
import engine.Events;
import engine.MainLoop;
import engine.Scene;
import haxe.ui.containers.Box;

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
	public var bus(get, never): EventBus<Events>;
	public var isActive(default, set): Bool = true;

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

	private function get_bus(): EventBus<Events> {
		return MainLoop.getInstance().events;
	}

	private function set_isActive(value: Bool): Bool {
		slot.visible = value;
		return value;
	}
}
