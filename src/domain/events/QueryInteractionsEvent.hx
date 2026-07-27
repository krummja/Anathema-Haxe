package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

typedef EntityInteraction = {
	var name: String;
	var evt: EntityEvent;
	var ?popScreen: Bool;
}

class QueryInteractionsEvent extends EntityEvent {
	public var interactor(default, null): Entity;
	public var interactions(default, null): Array<EntityInteraction>;

	public function new(interactor: Entity) {
		this.interactor = interactor;
		this.interactions = new Array();
	}

	public function add(interaction: EntityInteraction) {
		this.interactions.push(interaction);
	}
}
