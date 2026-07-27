package domain.components;

import ecs.Entity;
import data.AbilityType;
import data.SkillType;
import domain.events.QueryAbilitiesEvent;
import domain.events.QuerySkillsEvent;
import domain.events.QueryStatModEvent;
import data.AttributeType;
import ecs.Component;

class Attributes extends Component {
	public static function getFor(e: Entity, attrType: AttributeType) {
		var attributes = e.get(Attributes);
		if (attributes == null) {
			return 0;
		}

		return attributes.get(attrType);
	}

	// Physical
	@save public var strength: Int;
	@save public var dexterity: Int;
	@save public var stamina: Int;

	// Mental
	@save public var intelligence: Int;
	@save public var wits: Int;
	@save public var resolve: Int;

	// Social
	@save public var presence: Int;
	@save public var manipulation: Int;
	@save public var composure: Int;

	@save public var skills: Array<SkillType> = [];
	@save public var abilities: Array<AbilityType> = [];

	public function new(
		strength: Int,
		dexterity: Int,
		stamina: Int,
		intelligence: Int,
		wits: Int,
		resolve: Int,
		presence: Int,
		manipulation: Int,
		composure: Int
	) {
		this.strength = strength;
		this.dexterity = dexterity;
		this.stamina = stamina;
		this.intelligence = intelligence;
		this.wits = wits;
		this.resolve = resolve;
		this.presence = presence;
		this.manipulation = manipulation;
		this.composure = composure;

		addHandler(QueryStatModEvent, onQueryStatMod);
		addHandler(QuerySkillsEvent, onQuerySkills);
		addHandler(QueryAbilitiesEvent, onQueryAbilities);
	}

	public function get(attrType: AttributeType) {
		return switch (attrType) {
			case Physical(c):
				switch (c) {
					case Power: strength;
					case Finesse: dexterity;
					case Resistance: stamina;
				}

			case Mental(c):
				switch (c) {
					case Power: intelligence;
					case Finesse: wits;
					case Resistance: resolve;
				}

			case Social(c):
				switch (c) {
					case Power: presence;
					case Finesse: manipulation;
					case Resistance: composure;
				}
		}
	}

	private function onQueryStatMod(evt: QueryStatModEvent) {
		for (skill in skills) {
			var mods = [];
			evt.addMods(mods);
		}
	}

	private function onQuerySkills(evt: QuerySkillsEvent) {
		evt.addSkills(skills);
	}

	private function onQueryAbilities(evt: QueryAbilitiesEvent) {
		evt.addAbilities(abilities);
		for (skillType in skills) {}
	}
}
