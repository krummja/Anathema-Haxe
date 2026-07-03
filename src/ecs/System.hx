package ecs;

import engine.Frame;
import domain.World;
import engine.MainLoop;

class System {
	public var loop(get, null): MainLoop;
	public var world(get, null): World;

	public function update(frame: Frame) {}

	private inline function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}

	private inline function get_world(): World {
		return loop.world;
	}
}
