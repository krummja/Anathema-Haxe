package scenes.options;

import engine.Scene;
import engine.SettingsManager;
import haxe.ui.components.CheckBox;
import haxe.ui.components.Label;
import haxe.ui.components.OptionStepper;
import haxe.ui.containers.Box;
import haxe.ui.containers.HBox;
import haxe.ui.core.Component;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;

@:build(haxe.ui.macros.ComponentMacros.build("./components/setting-row.xml"))
class SettingRow extends HBox {
	public var settingLabel(default, set): String;

	public function new(id: String, label: String) {
		super();
		this.id = id;
		this.settingLabel = label;
		this.percentWidth = 100.0;
		this.percentHeight = 100.0;
		this.verticalAlign = "center";
		this.horizontalAlign = "center";
	}

	public function setValue(component: Component): Component {
		component.addClass("setting-value");
		slot.addComponent(component);
		return component;
	}

	private function set_settingLabel(value: String): String {
		settingName.text = value;
		return value;
	}
}

@:build(haxe.ui.macros.ComponentMacros.build("./components/options.xml"))
class OptionsView extends Box {
	@:allow(scenes.options.OptionsScene)
	private var onBackClick: (MouseEvent) -> Void;

	@:allow(scenes.options.OptionsScene)
	private var onSaveClick: (MouseEvent) -> Void;

	@:allow(scenes.options.OptionsScene)
	private var optResolution: OptionStepper;

	@:allow(scenes.options.OptionsScene)
	private var optFullscreen: OptionStepper;

	@:allow(scenes.options.OptionsScene)
	private var optVsync: CheckBox;

	@:allow(scenes.options.OptionsScene)
	private var onOptResolutionChange: (UIEvent) -> Void;

	@:allow(scenes.options.OptionsScene)
	private var onOptFullscreenChange: (UIEvent) -> Void;

	@:allow(scenes.options.OptionsScene)
	private var onOptVsyncChange: (UIEvent) -> Void;

	private var scene: Scene;

	private var transientSettings: Settings;

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		this.transientSettings = Reflect.copy(SettingsManager.settings);
		this.scene.loop.render(HUD, this);

		configureGeneral();
		configureDisplay();
		configureGraphics();
	}

	private function configureGeneral() {
		var row1 = new SettingRow("setting1", "Test Setting");
		var row1Val = new CheckBox();
		row1.setValue(row1Val);
		general.addComponent(row1);
	}

	private function configureDisplay() {
		var _resW = transientSettings.display.resolutionWidth;
		var _resH = transientSettings.display.resolutionHeight;

		// Resolution options
		// var rowResolution = new SettingRow("resolution", "Resolution");

		// optResolution = new OptionStepper();

		// // Construct data source for resolution stepper
		// var resolutionValues = [];
		// var currentIndex: Int = -1;
		// for (i => value in SettingsManager.RESOLUTIONS) {
		// 	resolutionValues.push({text: '${value.w} x ${value.h}'});
		// 	if (value.w == _resW && value.h == _resH) {
		// 		currentIndex = i;
		// 	}
		// }

		// optResolution.selectedIndex = currentIndex;
		// optResolution.dataSource = new ArrayDataSource();
		// for (value in resolutionValues) {
		// 	optResolution.dataSource.add(value);
		// }

		// rowResolution.setValue(optResolution);
		// display.addComponent(rowResolution);

		// Fullscreen options
		var rowFullscreen = new SettingRow("fullscreen", "Fullscreen");
		// optFullscreen = new CheckBox();
		optFullscreen = new OptionStepper();

		optFullscreen.selectedIndex = 0;
		optFullscreen.dataSource = new ArrayDataSource();
		optFullscreen.dataSource.add("Windowed");
		optFullscreen.dataSource.add("Borderless");
		optFullscreen.dataSource.add("Fullscreen");

		optFullscreen.value = SettingsManager.settings.display.fullScreen;
		rowFullscreen.setValue(optFullscreen);
		display.addComponent(rowFullscreen);
	}

	private function configureGraphics() {
		var rowVsync = new SettingRow("vsync", "Vertical Sync");
		optVsync = new CheckBox();
		optVsync.value = SettingsManager.settings.graphics.vsyncEnabled;
		rowVsync.setValue(optVsync);
		graphics.addComponent(rowVsync);
	}

	@:bind(optResolution, UIEvent.CHANGE)
	private function _onOptResolutionChange(e: UIEvent) {
		if (this.onOptResolutionChange != null) {
			this.onOptResolutionChange(e);
		}
	}

	@:bind(optFullscreen, UIEvent.CHANGE)
	private function _onOptFullscreenChange(e: UIEvent) {
		if (this.onOptFullscreenChange != null) {
			this.onOptFullscreenChange(e);
		}
	}

	@:bind(optVsync, UIEvent.CHANGE)
	private function _onOptVsyncChange(e: UIEvent) {
		if (this.onOptVsyncChange != null) {
			this.onOptVsyncChange(e);
		}
	}

	@:bind(btnBack, MouseEvent.CLICK)
	private function _onBackClick(value: MouseEvent) {
		if (this.onBackClick != null) {
			this.onBackClick(value);
		}
	}

	@:bind(btnSave, MouseEvent.CLICK)
	private function _onSaveClick(value: MouseEvent) {
		if (this.onSaveClick != null) {
			this.onSaveClick(value);
		}
	}
}
