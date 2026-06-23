package engine;

import echoes.System;
import echoes.SystemList;
import echoes.Echoes;

enum SystemKey {
	PRE_UPDATE;
	ON_UPDATE;
	POST_UPDATE;
	FIXED_UPDATE;
}

class SystemManager {
	public var loop(get, never): MainLoop;

	private var preUpdate: SystemList = new SystemList();
	private var onUpdate: SystemList = new SystemList();
	private var postUpdate: SystemList = new SystemList();
	private var fixedUpdate: SystemList = new SystemList();

	public function new() {
		fixedUpdate.clock.setFixedTickLength(1 / 30);
	}

	public function activateAll() {
		preUpdate.activate();
		onUpdate.activate();
		postUpdate.activate();
		fixedUpdate.activate();
	}

	public function addSystem(key: SystemKey, system: System) {
		switch (key) {
			case PRE_UPDATE:
				preUpdate.add(system);
			case ON_UPDATE:
				onUpdate.add(system);
			case POST_UPDATE:
				postUpdate.add(system);
			case FIXED_UPDATE:
				fixedUpdate.add(system);
		}
	}

	public function update() {
		Echoes.update();
	}

	private function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}
}
