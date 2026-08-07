package domain.stats;

class StatFortitude extends Stat {
	public function new() {
		super(Fortitude, [Physical(Resistance)]);
	}
}
