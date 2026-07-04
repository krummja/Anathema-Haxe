package engine;

import sys.FileSystem;
import common.util.FS;
import data.save.SaveWorld;
import hxd.Save;
import data.save.SaveChunk;

class FileManager {
	private var saveName: String;
	var saveDirectory = 'saves';

	public function new() {}

	public function setSaveName(name: String) {
		saveName = name;
		FileSystem.createDirectory(filePath(['chunks']));
	}

	public function saveChunk(data: SaveChunk): Bool {
		var isSaved = Save.save(data, filePath(['chunks', 'chunk-${data.idx}']));
		if (!isSaved) {
			trace('Chunk not saved!', data.idx);
		}

		return isSaved;
	}

	public function tryReadChunk(idx: Int): Null<SaveChunk> {
		var name = filePath(['chunks', 'chunk-$idx']);
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
