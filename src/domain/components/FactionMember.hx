package domain.components;

import domain.events.AttackedEvent;
import engine.Factions;
import engine.Faction;
import data.FactionType;
import ecs.Component;

typedef FactionModifier = {
	var value: Int;
}

class FactionMember extends Component {
	@save public var factionType: FactionType;
	@save public var modifiers: Map<FactionType, FactionModifier>;

	public var faction(get, never): Faction;

	public function new(factionType: FactionType) {
		this.factionType = factionType;
		this.modifiers = [];

		addHandler(AttackedEvent, onAttacked);
	}

	public function setModifier(target: FactionType, value: Int) {
		modifiers.set(target, {
			value: value,
		});
	}

	public function getModifier(target: FactionType): FactionModifier {
		return modifiers.get(target);
	}

	public function clearModifiers() {
		modifiers.clear();
	}

	private function onAttacked(evt: AttackedEvent) {}

	private function get_faction(): Faction {
		return Factions.get(factionType);
	}
}
