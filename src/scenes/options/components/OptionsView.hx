package scenes.options.components;

import scenes.ui.ComponentPathUtils;
import haxe.ui.backend.heaps.StyleHelper;
import haxe.ui.components.Label;
import haxe.ui.data.ArrayDataSource;
import engine.SettingsManager;
import haxe.ui.core.Component;
import haxe.ui.components.OptionStepper;
import haxe.ui.components.CheckBox;
import haxe.ui.containers.Box;
import haxe.ui.containers.HBox;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import engine.Scene;

@:build(haxe.ui.macros.ComponentMacros.build("./setting-row.xml"))
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

@:build(haxe.ui.macros.ComponentMacros.build("./options.xml"))
class OptionsView extends Box {
	private var scene: Scene;
	private var transientSettings: Settings;

	private var res: SettingRow;

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		this.transientSettings = Reflect.copy(SettingsManager.settings);
		this.scene.loop.render(HUD, this);

		configureGeneral();
		configureDisplay();
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
		var resolution = new SettingRow("resolution", "Resolution");

		var resolutionVal = new OptionStepper();

		// Construct data source for resolution stepper
		var resolutionValues = [];
		var currentIndex: Int = -1;
		for (i => value in SettingsManager.RESOLUTIONS) {
			resolutionValues.push({text: '${value.w} x ${value.h}'});
			if (value.w == _resW && value.h == _resH) {
				currentIndex = i;
			}
		}

		resolutionVal.selectedIndex = currentIndex;
		resolutionVal.dataSource = new ArrayDataSource();
		for (value in resolutionValues) {
			resolutionVal.dataSource.add(value);
		}

		resolution.setValue(resolutionVal);
		display.addComponent(resolution);

		// Additional options
	}

	@:bind(btnBack, MouseEvent.CLICK)
	private function onBackClick(value: MouseEvent) {}

	@:bind(btnSave, MouseEvent.CLICK)
	private function onSaveClick(value: MouseEvent) {}
}
