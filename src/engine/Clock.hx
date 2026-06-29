package engine;

class Clock {
	public static var DAY_START: Int = 0;
	public static var HOUR_START: Int = 10;
	public static var MINUTES_PER_HOUR: Int = 60;
	public static var HOURS_PER_DAY: Int = 24;

	public static var TICKS_PER_TURN: Int = 100;
	public static var TICKS_PER_MINUTE: Int = 100;
	public static var TICKS_PER_HOUR: Int = TICKS_PER_MINUTE * MINUTES_PER_HOUR;
	public static var TICKS_PER_DAY: Int = TICKS_PER_HOUR * HOURS_PER_DAY;

	public static function ticksToMinutes(ticks: Int): Float {
		return ticks / TICKS_PER_MINUTE;
	}

	public static function ticksToHours(ticks: Int): Float {
		return ticks / TICKS_PER_HOUR;
	}

	public static function ticksToDays(ticks: Int): Float {
		return ticks / TICKS_PER_DAY;
	}

	public var tick(default, null): Int;
	public var tickDelta(default, null): Int;
	public var turnDelta(default, null): Int;
	public var turn(get, never): Int;
	public var subTurn(get, never): Int;

	public var day(get, never): Int;
	public var hour(get, never): Int;
	public var minute(get, never): Int;
	public var progress(get, never): Float;

	public function new() {
		this.tick = 0;
		this.tickDelta = 0;
		this.turnDelta = 0;
	}

	public function incrementTick(delta: Int): Void {
		var prevTurn = this.turn;
		this.tickDelta += delta;
		this.tick += delta;
		this.turnDelta = this.turn - prevTurn;
	}

	public function clearDeltas(): Void {
		tickDelta = 0;
		turnDelta = 0;
	}

	private inline function get_turn(): Int {
		return Math.floor(this.tick / TICKS_PER_TURN);
	}

	private inline function get_subTurn(): Int {
		return Math.floor(this.tick % TICKS_PER_TURN);
	}

	private function get_day(): Int {
		var days = ticksToDays(tick + (TICKS_PER_HOUR * HOUR_START));
		return Math.floor(days);
	}

	private function get_hour(): Int {
		return (HOUR_START + Math.floor(ticksToHours(tick))) % HOURS_PER_DAY;
	}

	private function get_minute(): Int {
		return Math.floor(ticksToMinutes(tick)) % MINUTES_PER_HOUR;
	}

	private function get_progress(): Float {
		return (((HOUR_START) + ticksToHours(tick)) % HOURS_PER_DAY) / HOURS_PER_DAY;
	}

	@:allow(World)
	private function setTick(value: Int): Void {
		tick = value;
	}
}
