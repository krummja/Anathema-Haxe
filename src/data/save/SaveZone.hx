package data.save;

import data.save.GridSave;
import domain.terrain.Cell;

typedef ZoneSaveData = {
	var idx: Int;
	var width: Int;
	var height: Int;
	var tick: Int;
	var explored: GridSave<Bool>;
	var entities: GridSave<Array<EntitySaveData>>;
	var cells: GridSave<Cell>;
}
