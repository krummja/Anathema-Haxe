package domain.stats;

import domain.events.QueryStatModEvent;
import domain.components.Attributes;
import ecs.Entity;
import data.AttributeType;
import data.StatType;

class Stat {
	public var type: StatType;
	public var attributes: Array<AttributeType>;

	public function new(type: StatType, attributes: Array<AttributeType>) {
		this.type = type;
		this.attributes = attributes;
	}

	public function getModifiers(entity: Entity): Array<StatMod> {
		var evt = new QueryStatModEvent(type);
		entity.fireEvent(evt);
		return evt.mods;
	}

	public function getModifierSum(entity: Entity): Int {
		return getModifiers(entity).sum((s) -> s.mod).floor();
	}

	public function compute(entity: Entity): Int {
		var attribute = getAttribute(entity);
		var base = attribute == null ? 0 : Attributes.getFor(entity, attribute);
		var modifier = getModifierSum(entity);
		return base + modifier;
	}

	public function getAttribute(entity: Entity): Null<AttributeType> {
		return attributes.max((s) -> Attributes.getFor(entity, s));
	}
}
