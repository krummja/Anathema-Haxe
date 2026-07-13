package data.save;

import engine.Cell;
import data.save.GridSave;

typedef SaveChunk = {
	var idx: Int;
	var width: Int;
	var height: Int;
	var explored: GridSave<Bool>;
	var entities: GridSave<Array<EntitySaveData>>;
	var tick: Int;
	var cells: GridSave<Cell>;
}
