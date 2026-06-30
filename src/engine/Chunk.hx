package engine;

import echoes.Entity;
import components.Position;
import common.struct.IntPoint;
import common.struct.Grid;
import common.struct.GridMap;

class Chunk {
	public var entities(default, null): GridMap<Int>;
	public var exploration(default, null): Grid<Null<Bool>>;
	public var cells(default, null): Grid<Cell>;

	public var size(default, null): Int;
	public var chunkId(default, null): Int;
	public var zoneId(get, never): Int;
	public var zone(get, never): Zone;

	public var chunkPos(get, never): IntPoint;
	public var worldPos(get, never): IntPoint;

	public function new(chunkId: Int, size: Int) {
		this.chunkId = chunkId;
		this.size = size;
		this.entities = new GridMap(size, size);
		this.exploration = new Grid(size, size);
		this.cells = new Grid(size, size);
	}

	public function getEntityIdsAt(x: Float, y: Float): Array<Int> {
		return this.entities.get(Math.floor(x), Math.floor(y));
	}

	public function setEntityPosition(entity: Entity): Void {
		var local = entity.get(Position).asCoordinate().toChunkLocal().toWorld();
		entities.set(Math.floor(local.x), Math.floor(local.y), entity.id);
	}

	public function removeEntity(entity: Entity): Void {
		entities.remove(entity.id);
	}

	private function get_zoneId(): Int {
		var pos = chunkPos.divide(MainLoop.getInstance().world.chunksPerZone).floor();
		return MainLoop.getInstance().world.zones.getZoneId(pos);
	}

	private function get_zone(): Zone {
		return MainLoop.getInstance().world.zones.getZoneById(zoneId);
	}

	private function get_chunkPos(): IntPoint {
		return MainLoop.getInstance().world.chunks.getChunkPos(chunkId);
	}

	private function get_worldPos(): IntPoint {
		return chunkPos.multiply(size);
	}
}
