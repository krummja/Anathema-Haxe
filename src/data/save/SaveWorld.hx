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
	var zoneWidth: Int;
	var zoneHeight: Int;
	var zoneCountX: Int;
	var zoneCountY: Int;
	var detachedEntities: Array<EntitySaveData>;
}
