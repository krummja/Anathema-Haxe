package systems;

import engine.MainLoop;
import engine.World;
import echoes.View;
import echoes.Entity;

typedef Query = echoes.utils.ReadOnlyData.ReadOnlyArray<Entity>;

class System extends echoes.System {
	public var loop(get, never): engine.MainLoop;
	public var world(get, never): engine.World;
	public var query(get, never): Query;

	private function get_loop(): engine.MainLoop {
		return MainLoop.getInstance();
	}

	private function get_world(): engine.World {
		return MainLoop.getInstance().world;
	}

	private function get_query(): Query {
		return [];
	}
}
