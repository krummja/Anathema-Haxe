package engine;

import sys.FileSystem;
import common.util.FS;
import data.save.SaveWorld;
import hxd.Save;
import data.save.SaveZone.ZoneSaveData;

class FileManager {
	private var saveName: String;
	var saveDirectory = 'saves';

	public function new() {}

	public function setSaveName(name: String) {
		saveName = name;
		FileSystem.createDirectory(filePath(['zones']));
	}

	public function saveZone(data: ZoneSaveData): Bool {
		var isSaved = Save.save(data, filePath(['zones', 'zone-${data.idx}']));
		if (!isSaved) {
			trace('Zone not saved!', data.idx);
		}

		return isSaved;
	}

	public function tryReadZone(idx: Int): Null<ZoneSaveData> {
		var name = filePath(['zones', 'zone-$idx']);
		return Save.load(null, name);
	}

	public function saveWorld(data: SaveWorld): Bool {
		var isSaved = Save.save(data, filePath(['world']));
		if (!isSaved) {
			trace('World not saved!');
		}

		return isSaved;
	}

	public function tryReadWorld(): SaveWorld {
		var name = filePath(['world']);
		var data = Save.load(null, name);
		return data;
	}

	public function deleteSave(name: String) {
		FS.deletePath('$saveDirectory/$name', true);
	}

	private function filePath(parts: Array<String>): String {
		var all = [saveDirectory, saveName].concat(parts);
		return all.join("/");
	}
}
