package common.extensions;

import engine.EntityEvent;
import echoes.Entity;

class EntityExtensions {
	public static function fireEvent(entity: Entity, event: EntityEvent) {
		for (component in entity.getComponents()) {
			var instance = component.get(entity);
			var fn = Reflect.field(instance, "onEvent");
			Reflect.callMethod(instance, fn, [event]);
		}
	}
}
