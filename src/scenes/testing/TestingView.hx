package scenes.testing;

import common.struct.Grid;
import engine.Frame;
import engine.Scene;
import haxe.ui.containers.Box;
import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;
import scenes.testing.components.EquipmentSlotView;
import uilib.Meter;

typedef UINode = {
	var id: String;
	var active: Bool;
	var contents: String;
}

@:build(haxe.ui.macros.ComponentMacros.build("./components/testing.xml"))
class TestingView extends Box {
	private var scene: Scene;
	private var slotGrid: Grid<UINode>;

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		this.scene.loop.render(HUD, this);

		slotGrid = new Grid(4, 3);

		slotGrid.fillFn((idx) -> {
			return {
				id: '${idx}',
				active: true,
				contents: "",
			};
		});

		for (y in 0...slotGrid.height) {
			var row = addRow(y);
			gridRoot.addComponent(row);

			for (x in 0...slotGrid.width) {
				var slot = addSlot(x, y);
				row.addComponent(slot);
			}
		}

		scene.loop.events.createEvent(MOUSE_OVER_EQUIPMENT_SLOT);
		scene.loop.events.addEventListener(
			MOUSE_OVER_EQUIPMENT_SLOT,
			(event: EquipmentSlotEvent) -> {
				trace(event);
			}
		);

		gridRoot.addComponent(new Meter("HP", 325, 400, [
			0xaa0000,
			0xff9900,
			0x88aa00,
			0x00aa00,
		]));
	}

	public function update(frame: Frame) {
		// fps.text = '${frame.smoothFps.floor()}';
	}

	private function addRow(y: Int): HBox {
		var row = new HBox();
		row.id = 'row-${y}';
		row.styleNames = "grid-row";
		return row;
	}

	private function addSlot(x: Int, y: Int): Box {
		var box = new Box();
		box.id = 'box-${x}-${y}';
		box.styleNames = "grid-box";

		var slot = new EquipmentSlotView(x, y);
		slot.setSlotText("[Empty]");

		box.addComponent(slot);
		return box;
	}
}
