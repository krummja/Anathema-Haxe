package engine;

import common.util.FS;
import haxe.Json;
import sys.io.File;
import sys.FileSystem;

typedef ApplicationSettings = {
	var title: String;
}

typedef DisplaySettings = {
	resolutionWidth: Int,
	resolutionHeight: Int,
	fullScreen: String,
	scanlines: Bool,
	zoomLevel: Float,
	warpAmount: Float,
}

typedef GraphicsSettings = {
	vsyncEnabled: Bool,
}

typedef AudioSettings = {
	masterVolume: Int,
	effectsVolume: Int,
	musicVolume: Int,
	voiceVolume: Int,
	ambientVolume: Int,
}

typedef InputSettings = {}

typedef Settings = {
	application: ApplicationSettings,
	display: DisplaySettings,
	graphics: GraphicsSettings,
	audio: AudioSettings,
	input: InputSettings,
}

typedef Resolution = {w: Int, h: Int};

class SettingsManager {
	public static final RESOLUTIONS: Array<Resolution> = [
		{w: 1024, h: 768},
		{w: 1200, h: 800},
		{w: 1440, h: 900},
		{w: 1600, h: 900},
		{w: 1920, h: 1080},
	];

	public static var settings(default, set): Settings;

	private static var settingsDirectory: String = "settings";

	private static var dirty: Bool = false;

	public static function init(fileName: String) {
		if (!FileSystem.exists(settingsDirectory)) {
			FileSystem.createDirectory(settingsDirectory);
		}

		if (!FileSystem.exists(FS.filePath([settingsDirectory, '${fileName}.json']))) {
			SettingsManager.loadDefaults();
			SettingsManager.writeSettings('${fileName}.json');
		}

		SettingsManager.readSettings('${fileName}.json');

		trace("SettingsManager initialized");
	}

	private static function readSettings(name: String) {
		var fileData = File.getContent(FS.filePath([settingsDirectory, name]));
		var errors = new Array<json2object.Error>();
		settings = new json2object.JsonParser<Settings>(errors).fromJson(fileData, name);
	}

	private static function writeSettings(name: String) {
		var settingsData = Json.stringify(settings, "\t");
		File.saveContent(FS.filePath([settingsDirectory, name]), settingsData);
	}

	private static function loadDefaults() {
		SettingsManager.settings = {
			application: {
				title: "",
			},
			display: {
				resolutionWidth: 1200,
				resolutionHeight: 800,
				fullScreen: "Windowed",
				scanlines: true,
				warpAmount: 0.1,
				zoomLevel: 1.5,
			},
			graphics: {
				vsyncEnabled: true,
			},
			audio: {
				masterVolume: 100,
				ambientVolume: 100,
				voiceVolume: 100,
				musicVolume: 100,
				effectsVolume: 100,
			},
			input: {},
		};
	}

	private static function set_settings(value: Settings): Settings {
		SettingsManager.settings = value;
		SettingsManager.writeSettings("settings.json");
		return value;
	}
}
