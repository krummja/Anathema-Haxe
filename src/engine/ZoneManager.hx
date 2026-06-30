package engine;

import common.struct.IntPoint;
import common.struct.Coordinate;
import common.struct.Grid;

class ZoneManager {
	public var zones: Grid<Zone>;
	public var zoneCountX(get, never): Int;
	public var zoneCountY(get, never): Int;

	public function new() {}

	public function initialize(): Void {
		this.zones = new Grid<Zone>(this.zoneCountX, this.zoneCountY);
		this.zones.fillFn((idx) -> new Zone(idx));
	}

	public function getZoneByCoordinate(coord: Coordinate) {
		var idx = coord.toZoneId();
		return getZoneById(idx);
	}

	public function getZoneById(idx: Int) {
		return zones.getAt(idx);
	}

	public function getZonePos(idx: Int) {
		return this.zones.coord(idx);
	}

	public function getZoneId(pos: IntPoint): Int {
		return zones.id(pos.x, pos.y);
	}

	private function get_zoneCountX(): Int {
		return MainLoop.getInstance().world.zoneCountX;
	}

	private function get_zoneCountY(): Int {
		return MainLoop.getInstance().world.zoneCountY;
	}
}
