package domain.components;

import domain.events.UnequippedEvent;
import domain.events.QueryEquippedEvent.QueryEquippedEvent;
import domain.events.QueryStatModEquippedEvent;
import domain.events.QueryStatModEvent;
import domain.events.MeleeEvent;
import domain.events.MovedEvent;
import ecs.Entity;
import data.WeaponFamilyType;
import data.EquipmentSlotType;
import ecs.Component;

class EquipmentSlot extends Component {
	private static var allowMultiple = true;

	@save public var contentId: String = "";
	@save public var name: String;
	@save public var slotKey: String;
	@save public var slotType: EquipmentSlotType;
	@save public var isPrimary: Bool;
	@save public var defaultWeapon: WeaponFamilyType;

	public var content(get, never): Entity;
	public var isEmpty(get, never): Bool;
	public var isExtraSlot(get, never): Bool;
	public var displayName(get, never): String;
	public var contentDisplay(get, never): String;

	public function new(name: String, slotKey: String, slotType: EquipmentSlotType, isPrimary: Bool = false, ?defaultWeapon: WeaponFamilyType) {
		this.name = name;
		this.slotKey = slotKey;
		this.slotType = slotType;
		this.isPrimary = isPrimary;
		this.defaultWeapon = defaultWeapon;

		addHandler(QueryStatModEvent, onQueryStatMod);
		addHandler(MeleeEvent, onMelee);
		addHandler(MovedEvent, onMoved);
		addHandler(QueryEquippedEvent, onQueryEquipped);
	}

	public function equip(equipment: Entity) {
		unequip();

		var eq = equipment.get(Equipment);
		var extraSlotKey: String = null;

		if (eq.extraSlotTypes.length > 0) {
			// TODO
		}

		// TODO Stacking

		equipment.add(new IsEquipped(entity.id, slotKey, extraSlotKey));
		contentId = equipment.id;
	}

	public function unequip(combine: Bool = true): Bool {
		if (isEmpty) {
			return false;
		}

		var c = content;
		contentId = "";
		var equipped = c.get(IsEquipped);

		// TODO

		c.remove(IsEquipped);

		// TODO

		c.fireEvent(new UnequippedEvent());

		return true;
	}

	private function onMoved(evt: MovedEvent) {
		if (!isEmpty) {
			content.fireEvent(evt);
		}
	}

	private function onMelee(evt: MeleeEvent) {
		if (isEmpty) {
			if (defaultWeapon != null) {
				return;
			}
		}

		if (isPrimary && !isExtraSlot) {
			content.fireEvent(evt);
		}
	}

	private function onQueryStatMod(evt: QueryStatModEvent) {
		if (content == null) {
			return;
		}

		var equipped = new QueryStatModEquippedEvent(evt.stat);
		equipped.mods = evt.mods;

		content.fireEvent(equipped);
	}

	private function onQueryEquipped(evt: QueryEquippedEvent) {
		if (isEmpty || isExtraSlot) {
			return;
		}

		var weapon = content.get(Weapon);

		if (weapon == null) {
			return;
		}

		evt.add(weapon, this);
	}

	private function get_content(): Entity {
		return entity.registry.getEntity(contentId);
	}

	private function get_isEmpty(): Bool {
		return content == null;
	}

	private function get_displayName(): String {
		return '${name} [${contentDisplay}]';
	}

	private function get_contentDisplay(): String {
		if (isEmpty) {
			return 'empty';
		}

		return '${content.get(Moniker).baseName}';
	}

	private function get_isExtraSlot(): Bool {
		if (isEmpty) {
			return false;
		}

		var equipped = content.get(IsEquipped);
		return equipped.extraSlot == this;
	}
}
