package scenes.testing.components;

import engine.EventBus;
import engine.Events;
import engine.MainLoop;
import haxe.ui.containers.Box;
import haxe.ui.events.MouseEvent;
import uilib.NineSlicePanel;

typedef EquipmentSlotEvent = {
	var id: String;
	var active: Bool;
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
	public var bus(get, never): EventBus<Events>;
	public var isActive(default, set): Bool = true;

	public function new(x: Int, y: Int) {
		super();

		slotGraphic.customStyle = {
			width: 50,
			height: 50,
			horizontalAlign: "center",
		};

		var panel = new NineSlicePanel("images/equipment-slot.png", 48, 48, 2);
		slotGraphic.addComponent(panel);

		slot.onMouseOver = _onMouseOver;

		setId(x, y);
	}

	public function setId(x: Int, y: Int) {
		id = 'slot-${x}-${y}';
	}

	public function setSlotText(value: String): Void {
		slotText.text = value;
	}

	private function _onMouseOver(event: MouseEvent) {
		bus.callEvent(MOUSE_OVER_EQUIPMENT_SLOT, {
			id: this.id,
			active: slot.visible,
		});
	}

	private function get_bus(): EventBus<Events> {
		return MainLoop.getInstance().events;
	}

	private function set_isActive(value: Bool): Bool {
		slot.visible = value;
		return value;
	}
}
