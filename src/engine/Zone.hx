package engine;

import common.struct.IntPoint;

class Zone {
	public var zoneId(default, null): Int;
	public var zonePos(get, never): IntPoint;
	public var worldPos(get, never): IntPoint;
	public var size(get, never): Int;

	public function new(zoneId: Int) {
		this.zoneId = zoneId;
	}

	public function getChunks(): Array<Chunk> {
		var world = MainLoop.getInstance().world;
		var baseChunkPos = zonePos.multiply(world.chunksPerZone);

		var chunks = new Array<Chunk>();

		for (x in 0...world.chunksPerZone) {
			for (y in 0...world.chunksPerZone) {
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
		return zonePos.multiply(MainLoop.getInstance().world.zoneSize);
	}

	private function get_size(): Int {
		return MainLoop.getInstance().world.zoneSize;
	}
}
