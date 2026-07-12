package domain.components;

import ecs.Component;
import domain.events.ConsumeEnergyEvent;

class Energy extends Component {
	@save public var value(default, null): Int = 5;

	public var hasEnergy(get, never): Bool;

	public function new(value: Int = 0) {
		this.value = value;
		addHandler(ConsumeEnergyEvent, onConsumeEnergy);
	}

	public function addEnergy(value: Int) {
		this.value += value;
		if (this.value > 0) {
			this.value = 0;
		}
	}

	public function consumeEnergy(value: Int) {
		addEnergy(-1 * value);
	}

	private function onConsumeEnergy(evt: ConsumeEnergyEvent) {
		consumeEnergy(evt.value);
	}

	private inline function get_hasEnergy(): Bool {
		return value >= 0;
	}
}
