package data.save;

import data.save.SaveZone.ZoneSaveData;
import data.save.EntitySaveData;

typedef SavePlayer = {
	var entity: EntitySaveData;
}

typedef SaveWorld = {
	var seed: Int;
	var player: SavePlayer;
	var zones: ZoneSaveData;
	var tick: Int;
	var chunkSize: Int;
	var chunkCountX: Int;
	var chunkCountY: Int;
	var detachedEntities: Array<EntitySaveData>;
}
