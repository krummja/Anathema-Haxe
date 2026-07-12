package common.tools;

@:generic
class Buffer<T> {
	var values: Array<T>;

	public var size(default, null): Int;

	public function new(size: Int = 30) {
		values = new Array();
		this.size = size;
	}

	public function push(value: T) {
		values.push(value);
		if (values.length > size) {
			values.shift();
		}
	}

	public function peek(): T {
		return values[values.length - 1];
	}

	public inline function iterator() {
		return values.iterator();
	}
}

class Meter {
	public var buffer(default, null): Buffer<Float>;
	public var name(default, null): String;
	public var latest(default, null): Float;
	public var isRunning(default, null): Bool;
	public var startTime(default, null): Float;

	public function new(name: String = "unknown", bufferSize: Int = 60) {
		this.name = name;
		isRunning = false;
		buffer = new Buffer(bufferSize);
	}

	public function start() {
		isRunning = true;
		startTime = now();
	}

	public function stop() {
		if (isRunning) {
			latest = now() - startTime;
			buffer.push(latest);
		}
	}

	public inline function iterator() {
		return buffer.iterator();
	}

	private inline function now() {
		return haxe.Timer.stamp() * 1000.0;
	}
}

typedef FrameSnapshot = {
	var total: Float;
	var meters: Map<String, Float>;
}

class Performance {
	public static var snapshots: Buffer<FrameSnapshot> = new Buffer<FrameSnapshot>();
	static var meters: Map<String, Meter> = new Map();

	static function getOrCreateMeter(name: String): Meter {
		var existing = meters.get(name);

		if (existing == null) {
			var meter = new Meter(name);

			meters.set(name, meter);

			return meter;
		}

		return existing;
	}

	public static function start(name: String): () -> String {
		var meter = getOrCreateMeter(name);
		meter.start();
		return () -> toString(name);
	}

	public static function stop(name: String, showTrace: Bool = false) {
		var meter = getOrCreateMeter(name);
		meter.stop();
		if (showTrace) {
			trace(toString(name));
		}
	}

	public static function get(name: String) {
		return getOrCreateMeter(name);
	}

	public static function trace(name: String) {
		trace(toString(name));
	}

	public static function toString(name: String) {
		var val = getOrCreateMeter(name).latest;
		var trunc = Math.floor(val * 100) / 100;

		return '${name} ${trunc}ms';
	}

	public static function percent(name: String) {
		var snapshot = snapshots.peek();
		return snapshot.meters.get(name);
	}

	public static function update(dt: Float) {
		var percentages = new Map<String, Float>();

		for (name => meter in meters) {
			percentages.set(name, meter.latest / dt);
		}

		snapshots.push({
			total: dt,
			meters: percentages
		});
	}

	public static function toTable() {
		var headerRow = "";
		headerRow += 'name'.lpad(30);
		headerRow += 'avg'.lpad(20);
		headerRow += 'max'.lpad(20);

		var totalWidth = headerRow.length + 4;

		trace(headerRow);
		trace([for (i in 0...totalWidth) '-'].join(""));

		for (meter in meters) {
			// Name
			var name = meter.name;

			// Max
			var max = meter.buffer.max((m) -> m);

			// Average
			var sum = meter.buffer.sum((m) -> m);
			var total = meter.buffer.size;
			var average = total / sum;

			var dataRow = "";
			dataRow += name.lpad(30);
			dataRow += (average.roundTo().toString() + "ms").lpad(20);
			dataRow += (max.roundTo().toString() + "ms").lpad(20);

			trace(dataRow);
		}
	}
}
