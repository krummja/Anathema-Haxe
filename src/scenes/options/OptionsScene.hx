package scenes.options;

import engine.Scene;
import engine.SettingsManager;

class OptionsScene extends Scene {
	private var transientSettings: Settings;
	private var properties: scenes.options.OptionsView;

	public function new() {}

	public override function onEnter() {
		transientSettings = Reflect.copy(SettingsManager.settings);
		this.properties = new scenes.options.OptionsView(this);

		properties.onOptResolutionChange = function(e) {
			var value = this.properties.optResolution.value.text;
			var resValues: Array<String> = value.split(" x ");
			transientSettings.display.resolutionWidth = Std.parseInt(resValues[0]);
			transientSettings.display.resolutionHeight = Std.parseInt(resValues[1]);
		}

		properties.onOptFullscreenChange = function(e) {
			var value = this.properties.optFullscreen.value;
			transientSettings.display.fullScreen = value;
		}

		properties.onOptVsyncChange = function(e) {
			var value = this.properties.optVsync.value;
			transientSettings.graphics.vsyncEnabled = value;
		}

		properties.onBackClick = function(e) {
			loop.scenes.pop();
		}

		properties.onSaveClick = function(e) {
			trace(transientSettings);
			SettingsManager.settings = transientSettings;
			loop.applySettings();
			loop.scenes.pop();
		}

		this.ui.addComponent(properties);
	}

	public override function onDestroy() {
		transientSettings = null;
		properties = null;
		this.ui.removeChildren();
		this.ui.remove();
	}
}
