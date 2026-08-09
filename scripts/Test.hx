typedef Datum = {
	var foo: String;
}

typedef DataType = {
	> Datum,
	var bar: String;
}

class Test {
	public static function main() {
		test({foo: "foo", bar: "bar"});
	}

	@:generic
	public static function test<T: Datum>(datum: T) {
		trace(datum);
	}
}
