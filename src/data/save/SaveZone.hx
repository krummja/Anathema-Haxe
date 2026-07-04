package data.save;

import data.save.GridSave;

typedef ZoneSaveData = {
	var zoneId: Int;
}

typedef SaveZones = {
	var zones: GridSave<ZoneSaveData>;
}
