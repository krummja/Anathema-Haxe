package domain;


class Clock
{
    public static var DAY_START: Int = 0;
    public static var HOUR_START: Int = 10;

    public static var MINUTES_PER_HOUR: Int = 60;
    public static var HOURS_PER_DAY: Int = 24;

    public static var TICKS_PER_TURN: Int = 100;
    public static var TICKS_PER_MINUTE: Int = 100;
    public static var TICKS_PER_HOUR: Int = TICKS_PER_MINUTE * MINUTES_PER_HOUR;
    public static var TICKS_PER_DAY: Int = TICKS_PER_HOUR * HOURS_PER_DAY;

    public static function ticksToMinutes(ticks: Int): Float
    {
        return ticks / TICKS_PER_MINUTE;
    }

    public static function ticksToHours(ticks: Int): Float
    {
        return ticks / TICKS_PER_HOUR;
    }

    public static function ticksToDays(ticks: Int): Float
    {
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

    public function new()
    {
        this.tick = 0;
        this.tickDelta = 0;
        this.turnDelta = 0;
    }

    public function incrementTick(delta: Float): Void
    {
        var prevTurn = this.turn;

        this.tickDelta += delta.floor();
        this.tick += delta.floor();

        this.turnDelta = this.turn - prevTurn;
    }

    public function clearDeltas(): Void
    {
        this.tickDelta = 0;
        this.turnDelta = 0;
    }

    public function getDaylight(): Float
    {
        var d = ticksToDays(this.tick + (TICKS_PER_HOUR * HOUR_START));
        var x = d - d.floor();
        return 1 - ((Math.cos(2 * Math.PI * x) + 1) / 2).pow(2);
    }

    private inline function get_turn(): Int
    {
        return (this.tick / TICKS_PER_TURN).floor();
    }

    private inline function get_subTurn(): Int
    {
        return (this.tick % TICKS_PER_TURN).floor();
    }

    private function get_day(): Int
    {
        var days = 0;
        return days.floor();
    }

    private function get_hour(): Int
    {
        return 0;
    }

    private function get_minute(): Int
    {
        return 0;
    }

    private function get_progress(): Float
    {
        return 0.0;
    }
}
