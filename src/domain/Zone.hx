package domain;

import common.struct.Grid;
import common.struct.GridMap;
import common.struct.IntPoint;
import data.save.SaveZone.ZoneSaveData;
import domain.terrain.Cell;
import ecs.Entity;
import ecs.Registry;
import engine.ZoneView;
import shaders.SpriteShader;

class Zone {
	public var entities(default, null): GridMap<String>;
	public var exploration(default, null): Grid<Null<Bool>>;
	public var isLoaded(default, null): Bool;
	public var cells(default, null): Grid<Cell>;

	public var width(default, null): Int;
	public var height(default, null): Int;
	public var zoneId(default, null): Int;

	public var zonePos(get, never): IntPoint;
	public var worldPos(get, never): IntPoint;

	private var view: ZoneView;

	public function new(zoneId: Int, width: Int, height: Int) {
		this.zoneId = zoneId;
		this.width = width;
		this.height = height;
		this.cells = new Grid(width, height);
		this.view = new ZoneView(width, height);
	}

	public function load(?save: ZoneSaveData) {
		if (isLoaded) {
			return;
		}

		isLoaded = true;

		this.entities = new GridMap(width, height);
		this.exploration = new Grid(width, height);
		this.cells = new Grid(width, height);
		view.load();

		if (save == null) {
			// Default exploration to all false
			exploration.fill(false);

			// Pass this zone to the generator to populate cells
			World.instance.zones.zoneGen.generate(this);
		} else {
			var tickDelta = World.instance.clock.tick - save.tick;

			width = save.width;
			height = save.height;

			// Load cells
			cells.load(save.cells, (c) -> c);

			// Load exploration data
			exploration.load(save.explored, (v) -> v);
			for (e in exploration) {
				setExplore(e.pos, e.value, false);
			}

			// Load entities
			entities.load(save.entities, (edata) -> {
				return edata.map((data) -> {
					Entity.load(data, tickDelta);
					return data.id;
				});
			});
		}

		// Build tiles from cell data
		buildTiles();

		for (detachedId in Registry.instance.getDetachedEntities()) {
			var e = Registry.instance.getEntity(detachedId);
			if (e.zoneIdx == zoneId) {
				e.reattach();
				setEntityPosition(e);
			}
		}

		var pix = worldPos.asWorld().toPixel();
		view.place(pix.x, pix.y);
	}

	public function save(): ZoneSaveData {
		if (!isLoaded) {
			trace('Cannot save an unloaded zone');
			return null;
		}

		return {
			idx: zoneId,
			width: width,
			height: height,
			tick: World.instance.clock.tick,
			explored: exploration.save((v) -> v),
			cells: cells.save((v) -> v),
			entities: entities.save((v) -> {
				return v.filterMap((id) -> {
					var e = Registry.instance.getEntity(id);
					if (e != null && !e.isDetachable) {
						return {
							value: e.save(),
							filter: true,
						};
					}

					return {
						value: null,
						filter: false,
					};
				});
			})
		}
	}

	public function unload() {
		if (!isLoaded) {
			trace('Cannot unload an already unloaded zone');
			return;
		}

		view.unload();

		exploration = null;
		entities = null;
		cells = null;

		isLoaded = false;
	}

	public function buildTiles(): Void {
		view.build(cells);
	}

	public function getEntityIdsAt(x: Int, y: Int): Array<String> {
		if (!isLoaded) {
			return [];
		}

		return this.entities.get(x, y);
	}

	public function isExplored(pos: IntPoint): Bool {
		if (!isLoaded) {
			return false;
		}

		return exploration.get(pos.x, pos.y);
	}

	public function setExplore(pos: IntPoint, isExplored: Bool, isVisible: Bool) {
		if (!isLoaded) {
			trace('Warning: Loading zone on demand');
			World.instance.zones.loadZone(zoneId);
			return;
		}

		var idx = exploration.idx(pos.x, pos.y);
		if (idx < 0) {
			return;
		}

		exploration.setIdx(idx, isExplored);
		view.setExplore(pos, isExplored, isVisible);
	}

	public function getTileShader(pos: IntPoint): SpriteShader {
		return view.getShader(pos);
	}

	public function setEntityPosition(entity: Entity): Void {
		if (!isLoaded) {
			trace('Attempted to set entity in unloaded zone $zoneId: ${entity.id}');
			return;
		}

		var local = entity.pos.toZoneLocal().toWorld();
		entities.set(local.x.floor(), local.y.floor(), entity.id);
	}

	public function removeEntity(entity: Entity): Void {
		if (!isLoaded) {
			return;
		}
		entities.remove(entity.id);
	}

	public function getCell(localX: Int, localY: Int): Cell {
		if (!isLoaded) {
			return null;
		}

		return cells.get(localX, localY);
	}

	public function getCellCoord(idx: Int): IntPoint {
		return cells.coord(idx);
	}

	private function get_zonePos(): IntPoint {
		return World.instance.zones.getZonePos(zoneId);
	}

	private function get_worldPos(): IntPoint {
		return zonePos.multiply(width, height);
	}
}
