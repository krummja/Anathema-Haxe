// Relating to the division of reality, either pertaining to the Outer World (the Beyond)
// or the Inner World (the Foundation).
enum Division {
	Outer;
	Inner;
}

// Relating to the dynamics of the element.
// Fixed elements are stable, enduring, protective, inertial, heavy, etc.
// Volatile elements are unstable, transient, damaging, momentous, energetic, etc.
enum Nature {
	Fixed;
	Volatile;
}

// Relating to the aspect of primacy.
// Higher elements are divine, refined, mature, etc.
// Lower elements are base, primal, nascent, etc.
enum Aspect {
	Higher;
	Lower;
}

typedef Element = {
	var division: Division;
	var nature: Nature;
	var aspect: Aspect;
}

enum ElementKey {
	Heaven;
	Lake;
	Fire;
	Thunder;
	Earth;
	Mountain;
	Water;
	Wind;
}

class Main {
	public static function main() {
		var elements: Map<ElementKey, Element> = new Map();

		elements.set(Heaven, {
			division: Outer,
			nature: Fixed,
			aspect: Higher,
		});

		elements.set(Lake, {
			division: Outer,
			nature: Fixed,
			aspect: Lower,
		});

		elements.set(Fire, {
			division: Outer,
			nature: Volatile,
			aspect: Higher,
		});

		elements.set(Thunder, {
			division: Outer,
			nature: Volatile,
			aspect: Lower,
		});

		elements.set(Earth, {
			division: Inner,
			nature: Fixed,
			aspect: Higher,
		});

		elements.set(Mountain, {
			division: Inner,
			nature: Fixed,
			aspect: Lower,
		});

		elements.set(Water, {
			division: Inner,
			nature: Volatile,
			aspect: Higher,
		});

		elements.set(Wind, {
			division: Inner,
			nature: Volatile,
			aspect: Lower,
		});
	}
}
