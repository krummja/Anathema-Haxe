package engine;

import common.struct.Set;
import common.struct.IntPoint;
import common.struct.Grid;

class ChunkManager {
	public var chunkGen(default, null): ChunkGen;
	public var chunkCountX(get, null): Int;
	public var chunkCountY(get, null): Int;
	public var chunkWidth(get, null): Int;
	public var chunkHeight(get, null): Int;

	private var chunksToLoad: Set<Int>;
	private var chunksToUnload: Set<Int>;

	private var chunks: Grid<Chunk>;

	public function new() {
		chunkGen = new ChunkGen();
	}

	public function initialize() {
		this.chunks = new Grid<Chunk>(this.chunkCountX, this.chunkCountY);
		this.chunks.fillFn((idx) -> new Chunk(idx, chunkWidth, chunkHeight));
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

	public function saveChunk(chunkIdx: Int, unload: Bool = false) {
		var chunk = getChunkById(chunkIdx);
		var data = chunk.save();
		MainLoop.getInstance().files.saveChunk(data);
		if (unload) {
			chunk.unload();
		}
	}

	public function save(unload: Bool = false) {
		var loaded = chunks.filter((item) -> item.value.isLoaded).map((item) -> item.value.chunkId);
		for (chunkIdx in loaded) {
			saveChunk(chunkIdx, unload);
		}
	}

	public function loadChunk(chunkIdx: Int) {
		var chunk = getChunkById(chunkIdx);

		var data = MainLoop.getInstance().files.tryReadChunk(chunkIdx);

		if (chunk == null) {
			return;
		}

		if (data != null) {
			chunk.load(data);
		} else {
			chunk.load();
		}
	}

	public function update() {
		var toLoad = chunksToLoad.pop();

		if (toLoad != null) {
			var t = MainLoop.getInstance().frame.getTimeSinceLastFrame();
			if (t > 0.0005) {
				trace("Warning: delaying loading chunk for frame delay");
				return;
			}
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

	public inline function getChunkIdx(cx: Float, cy: Float) {
		return chunks.idx(cx.floor(), cy.floor());
	}

	public inline function getChunkById(chunkId: Int): Chunk {
		return chunks.getAt(chunkId);
	}

	public inline function getChunkIdxByWorld(wx: Float, wy: Float): Int {
		return getChunkIdx(Math.floor(wx / chunkWidth), Math.floor(wy / chunkHeight));
	}

	public overload extern inline function getChunk(cx: Float, cy: Float): Chunk {
		return getChunk(cx.floor(), cy.floor());
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

	private function get_chunkWidth(): Int {
		return MainLoop.getInstance().world.chunkWidth;
	}

	private function get_chunkHeight(): Int {
		return MainLoop.getInstance().world.chunkHeight;
	}
}
