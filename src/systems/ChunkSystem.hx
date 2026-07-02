package systems;

import echoes.Entity;
import components.*;

class ChunkSystem extends System {
	private var _query = getLinkedView(IsPlayer, Moved);

	@:add
	public function onEntityAdded(isPlayer: IsPlayer, moved: Moved, entity: Entity) {
		world.chunks.loadChunks(entity.get(Position).asCoordinate().toChunkId());
	}

	@:update
	public function update(time: Float) {
		world.chunks.update();
	}
}
