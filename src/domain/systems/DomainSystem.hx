package domain.systems;

import domain.World;
import ecs.System;
import engine.MainLoop;

class DomainSystem extends System {
	public var loop(get, null): MainLoop;
	public var world(get, null): World;

	private inline function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}

	private inline function get_world(): World {
		return loop.world;
	}
}
