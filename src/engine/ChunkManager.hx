package engine;

import common.struct.IntPoint;
import common.struct.Grid;

class ChunkManager {
	public var chunkCountX(get, null): Int;
	public var chunkCountY(get, null): Int;
	public var chunkSize(get, null): Int;

	private var chunks: Grid<Chunk>;

	public function new() {}

	public function initialize() {
		this.chunks = new Grid<Chunk>(this.chunkCountX, this.chunkCountY);
		this.chunks.fillFn((idx) -> new Chunk(idx, chunkSize));
	}

	public inline function getChunkId(cx: Float, cy: Float) {
		return this.chunks.id(Math.floor(cx), Math.floor(cy));
	}

	public inline function getChunkById(chunkId: Int): Chunk {
		return this.chunks.getAt(chunkId);
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
