package engine;

import data.FactionType;
import common.struct.DataRegistry;

class Factions {
	private static var factions: DataRegistry<FactionType, Faction>;

	public static function init() {
		factions = new DataRegistry();

		addFaction("Player", FACTION_PLAYER);
		addFaction("Village", FACTION_VILLAGE);
		addFaction("Wildlife", FACTION_WILDLIFE);
	}

	public static function get(type: FactionType): Faction {
		return factions.get(type);
	}

	private static function addFaction(name: String, type: FactionType) {
		factions.register(type, {
			name: name,
			type: type,
		});
	}
}
