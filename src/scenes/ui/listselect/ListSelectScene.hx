package scenes.ui.listselect;

import h2d.Bitmap;
import h2d.Interactive;
import h2d.Object;
import h2d.Text;
import h2d.Tile;
import engine.CommandManager.Command;
import engine.TileResources;
import shaders.SpriteShader;
import engine.ColorKey;
import engine.TextResources;
import scenes.ui.listselect.SelectableList;
import common.struct.Coordinate;
import engine.Scene;

typedef ListItem = {
	var title: String;
	var ?getIcon: () -> Bitmap;
	var ?detail: String;
	var onSelect: () -> Void;
}

typedef ListRow = {
	var ob: Bitmap;
	var bullet: Bitmap;
	var text: Text;
	var detail: Text;
	var data: ListItem;
	var isCancel: Bool;
}

class ListSelectScene extends Scene {
	public var onCancel: () -> Void;
	public var title(get, set): String;

	@:isVar public var targetPos(get, set): Null<Coordinate>;
	@:isVar public var pos(get, set): Coordinate;
	@:isVar public var cancelText(get, set): String;

	private var _pos: Coordinate;

	private var w: Int = 24;
	private var ob: Object;
	private var listOb: Object;
	private var items: Array<ListItem>;
	private var list: SelectableList<ListRow>;

	private var includeCancel: Bool = true;

	private var targetOb: Bitmap;
	private var titleOb: Text;
	private var cancelRow: ListRow;

	public function new(items: Array<ListItem>) {
		this.items = items;
		ob = new Object();
		listOb = new Object();
		listOb.y = 16;
		list = new SelectableList([]);
		onCancel = () -> loop.scenes.pop();

		_pos = new Coordinate(16, 16, SCREEN);

		var titleBkg = new Bitmap(Tile.fromColor(loop.CLEAR_COLOR, w * loop.UNIT_X, loop.UNIT_Y));

		ob.addChild(titleBkg);

		titleOb = new Text(TextResources.BIZCAT);
		titleOb.color = C_WHITE.toHxdColor();
		titleOb.text = "Select";

		cancelText = "Cancel";

		ob.addChild(titleOb);

		var shader = new SpriteShader(0xff0000);
		shader.ignoreLighting = 1;

		targetOb = new Bitmap(TileResources.get(TK_CURSOR), ob);
		targetOb.addShader(shader);
		targetOb.visible = false;

		loop.render(OVERLAY, targetOb);
	}

	public function setItems(items: Array<ListItem>) {
		this.items = items;
		listOb.removeChildren();

		var i = 0;
		var rows = items.map((d) -> makeRow(d, i++));

		if (includeCancel) {
			cancelRow = makeRow({
				title: cancelText,
				onSelect: doCancel,
			}, i, true);

			rows.push(cancelRow);
		}

		list.setItems(rows);
		updateRows();
	}

	public override function onEnter() {
		setItems(items);
		ob.addChild(listOb);

		ob.x = pos.x;
		ob.y = pos.y;

		loop.render(POPUP, ob);
	}

	private override function onDestroy() {
		ob.remove();
		targetOb.remove();
	}

	private override function onSuspend() {}

	private override function onResume() {}

	private function doSelect() {
		list.selected.data.onSelect();
	}

	private function doCancel() {
		onCancel();
	}

	private function onConfirm() {
		if (list.selected.isCancel) {
			doCancel();
		} else {
			doSelect();
		}
	}

	private function updateRows() {
		list.data.each((li: SelectableListItem<ListRow>) -> {
			var col = li.isSelected ? 0xFF0000 : 0xffffff;
			li.item.text.color = col.toHxdColor();
			li.item.detail.color = col.toHxdColor();
			li.item.bullet.tile = li.isSelected ? TileResources.get(TK_CURSOR) : TileResources.get(TK_LIST_DASH);
			li.item.bullet.getShader(SpriteShader).primary = col.toHxdColor().toVector();
		});
	}

	private function makeRow(item: ListItem, idx: Int, isCancel = false): ListRow {
		var tw = loop.UNIT_X * 2;
		var th = loop.UNIT_Y * 2;

		var fontHeight = 16;
		var fontOffset = ((th - fontHeight) / 2).floor();
		var left = 0;
		var rowOb = new Bitmap(Tile.fromColor(loop.CLEAR_COLOR, w * loop.UNIT_X, th));

		rowOb.y = idx * th;
		listOb.addChild(rowOb);

		var bullet = new Bitmap(TileResources.get(TK_LIST_DASH));
		bullet.addShader(new SpriteShader());
		bullet.x = left;
		bullet.y = fontOffset;
		left += loop.UNIT_X;
		rowOb.addChild(bullet);

		if (item.getIcon != null) {
			var icon = item.getIcon();
			icon.x = left;
			icon.y = 0;
			icon.scale(2);
			left += tw;
			rowOb.addChild(icon);
		}

		var text = new Text(TextResources.BIZCAT);
		text.color = 0xffffff.toHxdColor();
		left += 8;
		text.x = left;
		text.y = fontOffset;
		text.setScale(1);
		text.text = item.title;
		rowOb.addChild(text);

		var detail = new Text(TextResources.BIZCAT);
		detail.color = 0xffffff.toHxdColor();
		detail.x = left;
		detail.y = fontOffset;
		detail.setScale(1);
		detail.text = item.detail == null ? '' : item.detail;
		rowOb.addChild(detail);

		var interactive = new Interactive(w * loop.UNIT_X, th);
		interactive.onClick = (e) -> {
			list.selectIdx(idx);
			updateRows();
			onConfirm();
		}

		interactive.onOver = (e) -> {
			list.selectIdx(idx);
			updateRows();
		}

		rowOb.addChild(interactive);

		return {
			ob: rowOb,
			text: text,
			detail: detail,
			bullet: bullet,
			isCancel: isCancel,
			data: item,
		};
	}

	private function handleCmd(command: Command) {
		if (command == null) {
			return;
		}

		switch (command.type) {
			case CMD_MOVE_N:
				list.up();
				updateRows();
			case CMD_MOVE_S:
				list.down();
				updateRows();
			case CMD_WAIT:
			case CMD_CONFIRM:
				onConfirm();
			case CMD_CANCEL:
				doCancel();
			case _:
		}
	}

	private function get_title(): String {
		return titleOb.text;
	}

	private function set_title(value: String): String {
		return titleOb.text = value;
	}

	private function get_cancelText(): String {
		return cancelText;
	}

	private function set_cancelText(value: String): String {
		return cancelText = value;
	}

	private function get_targetPos(): Null<Coordinate> {
		return targetPos;
	}

	private function set_targetPos(value: Null<Coordinate>): Null<Coordinate> {
		if (value != null) {
			var p = value.toWorld().floor().toPixel();
			targetOb.visible = true;
			targetOb.x = p.x;
			targetOb.y = p.y;
		} else {
			targetOb.visible = false;
		}

		return targetPos = value;
	}

	private function get_pos(): Coordinate {
		return _pos;
	}

	private function set_pos(value: Coordinate): Coordinate {
		var s = value.toScreen();
		ob.x = s.x;
		ob.y = s.y;

		return s;
	}
}
