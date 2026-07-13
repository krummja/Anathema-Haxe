package engine;

import data.save.SaveZone.ZoneSaveData;
import common.struct.IntPoint;

class Zone {
	public static function load(data: ZoneSaveData): Zone {
		var z = new Zone(data.zoneId);
		return z;
	}

	public var zoneId(default, null): Int;
	public var zonePos(get, never): IntPoint;
	public var worldPos(get, never): IntPoint;
	public var width(get, never): Int;
	public var height(get, never): Int;

	public function new(zoneId: Int) {
		this.zoneId = zoneId;
	}

	public function save(): ZoneSaveData {
		return {
			zoneId: zoneId,
		};
	}

	public function getChunks(): Array<Chunk> {
		var world = MainLoop.getInstance().world;
		var baseChunkPos = zonePos.multiply(world.chunkSubdivision);

		var chunks = new Array<Chunk>();

		for (x in 0...world.chunkSubdivision) {
			for (y in 0...world.chunkSubdivision) {
				var chunkPos = baseChunkPos.add(x, y);
				var chunk = world.chunks.getChunk(chunkPos.x, chunkPos.y);
				chunks.push(chunk);
			}
		}

		return chunks;
	}

	private function get_zonePos(): IntPoint {
		return MainLoop.getInstance().world.zones.getZonePos(zoneId);
	}

	private function get_worldPos(): IntPoint {
		return zonePos.multiply(width, height);
	}

	private function get_width(): Int {
		return MainLoop.getInstance().world.zoneWidth;
	}

	private function get_height(): Int {
		return MainLoop.getInstance().world.zoneHeight;
	}
}
