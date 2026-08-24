package uilib;

import haxe.ui.containers.HBox;

@:xml('
    <hbox>
        <style>
            .meter {
                width: 100%;
                height: 100%;
            }

            #labelWrapper {
                height: 20px;
                margin-left: 20px;
            }

            #labelWrapper .label {
                vertical-align: center;
                color: white;
                font-style: bold;
            }

            .meterBar {
                width: 100%;
                height: 20px;
            }
        </style>
        <box styleName="meter">
            <progress pos="100" id="meterBar" styleName="meterBar" />
            <hbox id="labelWrapper">
                <slabel id="valueLabel" />
                <slabel id="currentLabel" />
                <slabel text="/" />
                <slabel id="maximumLabel" />
            </hbox>
        </box>
    </hbox>
')
class Meter extends HBox {
	public var label(default, set): String;

	@:isVar
	public var current(default, set): Int;

	@:isVar
	public var maximum(default, set): Int;

	private var colors: Array<Int>;

	public function new(label: String, current: Int, maximum: Int, colors: Array<Int>) {
		super();

		this.label = label;
		this.colors = colors;

		this.maximum = maximum;
		this.current = current;
	}

	private function updateMeter(): Void {
		var progress = meterBar.findComponent("progress-value");
		meterBar.pos = (current / maximum) * 100;
		var cIdx = current.mapValueToIndex(0, maximum, colors.length - 1);
		progress.customStyle.backgroundColor = colors[cIdx];
	}

	private function set_label(value: String): String {
		valueLabel.text = value;
		return value;
	}

	private function set_current(value: Int): Int {
		currentLabel.text = '${value}';
		this.current = value;

		updateMeter();

		return value;
	}

	private function set_maximum(value: Int): Int {
		maximumLabel.text = '${value}';
		this.maximum = value;
		return value;
	}
}
