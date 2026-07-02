package systems;

import echoes.Entity;
import echoes.utils.ReadOnlyData.ReadOnlyArray;
import components.IsDestroyed;
import components.Visible;
import components.Explored;

@:build(engine.Query.build("query", {
	all: [],
	any: [],
	none: [],
}))
@:build(engine.Query.build("secondary", {
	all: [],
	any: [],
	none: [],
}))
class TestSystem extends System {
	public var someQuery(get, never): ReadOnlyArray<Entity>;

	private var _someQuery = getLinkedView(Visible, Explored);

	private function get_someQuery(): ReadOnlyArray<Entity> {
		return this._someQuery.entities;
	}

	public function new() {
		trace(this.query);
		trace(this.secondary);
	}
}
