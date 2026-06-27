package systems;

import engine.MainLoop;

class System extends echoes.System {
	public var loop(get, never): engine.MainLoop;

	private function get_loop(): engine.MainLoop {
		return MainLoop.getInstance();
	}
}
