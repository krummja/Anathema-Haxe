package engine;

import common.struct.Set;
import common.struct.IntPoint;
import common.struct.Grid;

class ChunkManager {
	public var chunkGen(default, null): ChunkGen;
	public var chunkCountX(get, null): Int;
	public var chunkCountY(get, null): Int;
	public var chunkSize(get, null): Int;

	private var chunksToLoad: Set<Int>;
	private var chunksToUnload: Set<Int>;

	private var chunks: Grid<Chunk>;

	public function new() {
		chunkGen = new ChunkGen();
	}

	public function initialize() {
		this.chunks = new Grid<Chunk>(this.chunkCountX, this.chunkCountY);
		this.chunks.fillFn((idx) -> new Chunk(idx, chunkSize));
		chunksToLoad = new Set();
		chunksToUnload = new Set();
	}

	public function loadChunks(curChunk: Int) {
		var curChunkPos = getChunkPos(curChunk);
		var loaded = chunks.filter((item) -> item.value.isLoaded).map((item) -> item.value.chunkId);
		var activeChunkIdxs = new Set<Int>();

		for (x in [-2, -1, 0, 1, 2]) {
			for (y in [-2, -1, 0, 1, 2]) {
				var chunkPos = curChunkPos.add(x, y);
				if (chunkPos.x >= 0 || chunkPos.y >= 0 || chunkPos.x < chunkCountX || chunkPos.y < chunkCountY) {
					var chunkIdx = getChunkIdx(chunkPos.x, chunkPos.y);
					activeChunkIdxs.add(chunkIdx);
					chunksToUnload.remove(chunkIdx);
				}
			}
		}

		for (chunkIdx in loaded) {
			if (!activeChunkIdxs.has(chunkIdx)) {
				chunksToUnload.add(chunkIdx);
			}
		}

		chunksToLoad = new Set<Int>();

		for (chunkIdx in activeChunkIdxs) {
			if (!loaded.contains(chunkIdx)) {
				chunksToLoad.add(chunkIdx);
			}
		}
	}

	public function update() {
		var toLoad = chunksToLoad.pop();

		if (toLoad != null) {
			var t = MainLoop.getInstance().frame.getTimeSinceLastFrame();

			if (t > 0.0005) {
				trace('Warning: delaying loading chunk for frame delay');
				return;
			}

			if (toLoad != null) {
				loadChunk(toLoad);
			} else {
				var chunkIdx = chunksToUnload.pop();
				if (chunkIdx != null) {
					saveChunk(chunkIdx, true);
				}
			}
		}
	}

	public function loadChunk(chunkIdx: Int) {
		trace('Loading chunk ${chunkIdx}');
		var chunk = getChunkById(chunkIdx);
		if (chunk != null) {
			chunk.load();
		}
	}

	public function saveChunk(chunkIdx: Int, unload: Bool = false) {
		var chunk = getChunkById(chunkIdx);
		if (unload) {
			chunk.unload();
		}
	}

	public inline function getChunkIdx(cx: Float, cy: Float) {
		return this.chunks.idx(Math.floor(cx), Math.floor(cy));
	}

	public inline function getChunkById(chunkId: Int): Chunk {
		return this.chunks.getAt(chunkId);
	}

	public inline function getChunkIdxByWorld(wx: Float, wy: Float): Int {
		return getChunkIdx(Math.floor(wx / chunkSize), Math.floor(wy / chunkSize));
	}

	public overload extern inline function getChunk(cx: Float, cy: Float): Chunk {
		return getChunk(Math.floor(cx), Math.floor(cy));
	}

	public overload extern inline function getChunk(cx: Int, cy: Int): Chunk {
		return chunks.get(cx, cy);
	}

	public inline function getChunkPos(idx: Int): IntPoint {
		return chunks.coord(idx);
	}

	private function get_chunkCountX(): Int {
		return MainLoop.getInstance().world.chunkCountX;
	}

	private function get_chunkCountY(): Int {
		return MainLoop.getInstance().world.chunkCountY;
	}

	private function get_chunkSize(): Int {
		return MainLoop.getInstance().world.chunkSize;
	}
}
