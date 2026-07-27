package domain.events;

import domain.stats.StatMod;
import data.StatType;
import ecs.EntityEvent;

class QueryStatModEvent extends EntityEvent {
	public var stat: StatType;
	public var mods: Array<StatMod> = new Array();

	public function new(stat: StatType) {
		this.stat = stat;
	}

	public inline function addMod(mod: StatMod) {
		mods.push(mod);
	}

	public inline function addMods(mods: Array<StatMod>) {
		for (mod in mods) {
			addMod(mod);
		}
	}
}
