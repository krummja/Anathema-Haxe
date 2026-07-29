package domain;

import data.FactionType;
import data.save.SaveFactionManager;
import domain.components.FactionMember;
import ecs.Entity;
import haxe.EnumTools.EnumValueTools;

class FactionManager {
	private var relations: Map<String, Int>;
	private var hostileThreshold: Int = -200;

	public function new() {
		relations = new Map();
	}

	public function initialize() {
		relations = new Map();

		setRelation(FACTION_PLAYER, FACTION_WILDLIFE, -300);
		setRelation(FACTION_PLAYER, FACTION_VILLAGE, 100);
		setRelation(FACTION_VILLAGE, FACTION_WILDLIFE, -100);
	}

	public function save(): SaveFactionManager {
		return {
			relations: relations,
		};
	}

	public function load(data: SaveFactionManager) {
		relations = data.relations;
	}

	public function getEntityRelation(a: Entity, b: Entity): Int {
		var memberA = a.get(FactionMember);
		var memberB = b.get(FactionMember);

		if (memberA == null || memberB == null) {
			return 0;
		}

		var modA = memberA.getModifier(memberB.factionType);
		var modB = memberB.getModifier(memberA.factionType);

		if (modA != null || modB != null) {
			var modAV = modA == null ? 10_000 : modA.value;
			var modBV = modB == null ? 10_000 : modB.value;
			return Math.min(modAV, modBV).floor();
		}

		return getRelation(memberA.factionType, memberB.factionType);
	}

	public function areEntitiesHostile(a: Entity, b: Entity): Bool {
		var relation = getEntityRelation(a, b);
		return relation < hostileThreshold;
	}

	public function getRelation(a: FactionType, b: FactionType): Int {
		var key = getRelationKey(a, b);
		var relation = relations.get(key);
		return relation.or(0);
	}

	public function setRelation(a: FactionType, b: FactionType, value: Int) {
		var key = getRelationKey(a, b);
		relations.set(key, value);
	}

	public function changeRelation(a: FactionType, b: FactionType, delta: Int) {
		var key = getRelationKey(a, b);
		var relation = getRelation(a, b);
		relations.set(key, relation + delta);
	}

	public function getDisplay(value: Int, includeValue: Bool = false) {
		var str = getDisplayBasic(value);

		if (includeValue) {
			return '$str ($value)';
		}

		return str;
	}

	private function getDisplayBasic(value: Int): String {
		if (value <= -300) {
			return "Hated";
		}

		if (value <= -200) {
			return "Disliked";
		}

		if (value <= -100) {
			return "Unfriendly";
		}

		if (value >= 100) {
			return "Amicable";
		}

		if (value >= 200) {
			return "Friendly";
		}

		if (value >= 300) {
			return "Loyal";
		}

		return "Neutral";
	}

	private function getRelationKey(a: FactionType, b: FactionType): String {
		var k1 = EnumValueTools.getName(a);
		var k2 = EnumValueTools.getName(b);
		var keys = [k1, k2];
		keys.sort((s1, s2) -> s1 > s2 ? 1 : -1);
		return keys.join('-');
	}
}
