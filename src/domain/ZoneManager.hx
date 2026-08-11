package domain;

import common.struct.Coordinate;
import common.struct.Grid;
import common.struct.IntPoint;
import domain.terrain.ZoneGen;
import ecs.Entity;
import engine.MainLoop;

class ZoneManager implements ecs.EntityZoneTracker {
	public var zones: Grid<Zone>;
	public var zoneGen(default, null): ZoneGen;
	public var current(default, null): Zone;
	public var zoneCountX(get, never): Int;
	public var zoneCountY(get, never): Int;
	public var loop(get, never): MainLoop;

	public function new() {
		zoneGen = new ZoneGen();
	}

	public function initialize(): Void {
		this.zones = new Grid<Zone>(this.zoneCountX, this.zoneCountY);
		this.zones.fillFn((idx) -> new Zone(idx, World.instance.zoneWidth, World.instance.zoneHeight));
	}

	/**
	 * Discrete zone transition: saves and unloads the current zone (if any)
	 * and loads the target zone, making it current. Zones aren't streamed —
	 * exactly one is ever loaded at a time.
	 */
	public function travelTo(zoneId: Int): Void {
		if (current != null) {
			if (current.zoneId == zoneId) {
				return;
			}

			saveZone(current.zoneId, true);
		}

		loadZone(zoneId);
		current = getZoneById(zoneId);
	}

	public function loadZone(zoneIdx: Int) {
		var zone = getZoneById(zoneIdx);

		var data = loop.files.tryReadZone(zoneIdx);

		if (zone == null) {
			return;
		}

		if (data != null) {
			zone.load(data);
		} else {
			zone.load();
		}
	}

	public function saveZone(zoneIdx: Int, unload: Bool = false) {
		var zone = getZoneById(zoneIdx);
		var data = zone.save();

		loop.files.saveZone(data);

		if (unload) {
			zone.unload();
		}
	}

	public function save() {
		if (current != null) {
			saveZone(current.zoneId);
		}
	}

	public function getZoneByCoordinate(coord: Coordinate) {
		var idx = coord.toZoneId();
		return getZoneById(idx);
	}

	public function getZoneById(idx: Int) {
		return zones.getAt(idx);
	}

	public inline function getZoneIdxByWorld(wx: Float, wy: Float): Int {
		return zones.idx(Math.floor(wx / World.instance.zoneWidth), Math.floor(wy / World.instance.zoneHeight));
	}

	public overload extern inline function getZone(zx: Float, zy: Float): Zone {
		return getZone(Math.floor(zx), Math.floor(zy));
	}

	public overload extern inline function getZone(zx: Int, zy: Int): Zone {
		return zones.get(zx, zy);
	}

	public inline function getZonePos(idx: Int): IntPoint {
		return this.zones.coord(idx);
	}

	public inline function getZoneId(pos: IntPoint): Int {
		return zones.idx(pos.x, pos.y);
	}

	public function onEntityMoved(entity: Entity, prevZoneIdx: Int, nextZoneIdx: Int): Void {
		if (prevZoneIdx != nextZoneIdx) {
			var prevZone = getZoneById(prevZoneIdx);
			if (prevZone != null) {
				prevZone.removeEntity(entity);
			}
		}

		var nextZone = getZoneById(nextZoneIdx);
		if (nextZone != null) {
			nextZone.setEntityPosition(entity);
		}
	}

	public function onEntityDestroyed(entity: Entity, zoneIdx: Int): Void {
		var zone = getZoneById(zoneIdx);
		if (zone != null) {
			zone.removeEntity(entity);
		}
	}

	private function get_zoneCountX(): Int {
		return World.instance.zoneCountX;
	}

	private function get_zoneCountY(): Int {
		return World.instance.zoneCountY;
	}

	private function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}
}
