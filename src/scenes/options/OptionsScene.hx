package scenes.options;

import haxe.ui.components.Label;
import haxe.ui.containers.properties.PropertyGrid;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.data.DataSource;
import haxe.ui.events.UIEvent;
import haxe.ui.containers.properties.PropertyGroup;
import haxe.ui.containers.properties.Property;
import haxe.ui.containers.Box;
import engine.Scene;
import engine.SettingsManager;
import scenes.ui.Events;

@:generic
typedef DataValue<T> = {text: String, value: T};

@:generic
typedef PropertySettings<T> = {
	var id: String;
	var group: PropertyGroup;
	var label: String;
	var value: T;
}

@:xml('
<box width="100%" height="100%" style="padding: 8px;">
	<style>
		#test {
			color: #ff00ff;
		}
	</style>
	<vbox styleName="modal-background" width="100%" height="100%">
        <property-grid width="100%" height="100%">
			<property-group id="application" text="General" />
            <property-group id="display" text="Display" />
			<property-group id="graphics" text="Graphics" />
			<property-group id="audio" text="Audio" />
			<property-group id="input" text="Input" />
			<property-group id="test" text="Test">
				<property id="test" styleName="test" label="Test" type="boolean" />
			</property-group>
        </property-grid>

        <box width="100%" height="100%">
            <hbox width="100%">
                <button id="back" text="Back" horizontalAlign="left" />
                <button id="save" text="Save" horizontalAlign="right" />
            </hbox>
        </box>
    </vbox>
</box>
')
class OptionsView extends Box {
	public var onBackClick(default, set): ClickEvent;
	public var onSaveClick(default, set): ClickEvent;

	private var scene: Scene;
	private var settings: Settings;
	private var optVsync: Property;
	private var optFullscreen: Property;
	private var optResolution: Property;

	public function new(scene: Scene, settings: Settings) {
		super();
		this.scene = scene;
		this.settings = settings;
		this.scene.loop.render(HUD, this);

		var _vsync = settings.graphics.vsyncEnabled;
		var _fullscreen = settings.display.fullScreen;
		var _resW = settings.display.resolutionWidth;
		var _resH = settings.display.resolutionHeight;

		optVsync = addProperty("optVsync", graphics, "Vertical Sync", "boolean", _vsync);
		optFullscreen = addProperty("optFullscreen", display, "Fullscreen", "boolean", _fullscreen);

		var resolutionValues = [];
		for (i => value in SettingsManager.RESOLUTIONS) {
			resolutionValues.push({text: '${value.w}x${value.h}', value: '${i}'});
		}

		var currentValue: Int = -1;
		for (index => res in SettingsManager.RESOLUTIONS) {
			if (res.w == _resW && res.h == _resH) {
				currentValue = index;
			}
		}
		optResolution = addProperty("optResolution", display, "Resolution", "list", '$currentValue', resolutionValues);
	}

	private function addProperty<T = Null>(id: String, group: PropertyGroup, label: String, type: String, value: Dynamic, ?data: Array<DataValue<T>>): Property {
		var prop = new Property();
		prop.id = id;
		prop.label = label;
		prop.type = type;

		if (type == "list") {
			prop.dataSource = new ArrayDataSource();
			if (data != null) {
				for (datum in data) {
					prop.dataSource.add(datum);
				}
			}
		}

		prop.value = value;
		prop.customStyle = {
			color: 0xff00ff,
		};
		group.addComponent(prop);
		return prop;
	}

	@:bind(optVsync, UIEvent.CHANGE)
	private function onVsyncChange(e: UIEvent) {
		settings.graphics.vsyncEnabled = optVsync.value;
	}

	@:bind(optFullscreen, UIEvent.CHANGE)
	private function onFullscreenChange(e: UIEvent) {
		settings.display.fullScreen = optFullscreen.value;
	}

	@:bind(optResolution, UIEvent.CHANGE)
	private function onResolutionChange(e: UIEvent) {
		var value = optResolution.value.text;
		var resValues: Array<String> = value.split("x");
		settings.display.resolutionWidth = Std.parseInt(resValues[0]);
		settings.display.resolutionHeight = Std.parseInt(resValues[1]);
	}

	private function set_onBackClick(value: ClickEvent): ClickEvent {
		back.onClick = value;
		return value;
	}

	private function set_onSaveClick(value: ClickEvent): ClickEvent {
		save.onClick = value;
		return value;
	}
}

class OptionsScene extends Scene {
	private var transientSettings: Settings;
	private var properties: scenes.options.components.OptionsView;

	public function new() {}

	public override function onEnter() {
		transientSettings = Reflect.copy(SettingsManager.settings);
		this.properties = new scenes.options.components.OptionsView(this);

		// properties.onBackClick = function(e) {
		// 	loop.scenes.pop();
		// }

		// properties.onSaveClick = function(e) {
		// 	SettingsManager.settings = transientSettings;
		// 	loop.applySettings();
		// 	loop.scenes.pop();
		// }

		this.ui.addComponent(properties);
	}

	public override function onDestroy() {
		transientSettings = null;
		properties = null;
		this.ui.removeChildren();
		this.ui.remove();

		trace("Destroyed?");
	}
}
