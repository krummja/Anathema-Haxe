package engine;

class Frame {
	/**
	 * Delta time
	 */
	public var dt(get, null): Float;

	/**
	 * Frames per second
	 */
	public var fps(get, null): Float;

	public var spf(get, null): Float;

	public var smoothFps(get, null): Float;

	public var frameTimes(default, null): Array<Float> = [];

	/**
	 * Modifier that shows real FPS relative to desired FPS. This allows
	 * for the game to be frame-rate independent. Use this whenever moving
	 * objects on the screen.
	 *
	 * When tmod = 1, it means the game is running at the desired speed
	 * When tmod < 1, it means the game is running faster than desired
	 * When tmod > 1, it means the game is running slower than desired
	 */
	public var tmod(get, null): Float;

	/**
	 * The seconds since the game started running.
	 */
	public var elapsed(default, null): Float = 0;

	/**
	 * The number of frames since the game start.
	 */
	public var tick(default, null): Int = 0;

	@:allow(engine.MainLoop)
	private function new() {}

	@:allow(engine.MainLoop)
	private function update() {
		tick++;
		elapsed += dt;

		frameTimes.push(dt);
		if (frameTimes.length > 50) {
			frameTimes.shift();
		}
	}

	private function get_dt(): Float {
		return hxd.Timer.elapsedTime;
	}

	private function get_fps(): Float {
		return hxd.Timer.fps();
	}

	private function get_smoothFps(): Float {
		var totalTime: Float = 0.0;
		for (i in 0...frameTimes.length) {
			totalTime += frameTimes[i];
		}
		return frameTimes.length / totalTime;
	}

	private function get_tmod(): Float {
		return hxd.Timer.tmod;
	}

	private function get_spf(): Float {
		return tmod * (1 / fps);
	}
}
