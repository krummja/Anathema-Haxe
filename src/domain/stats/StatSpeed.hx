package domain.stats;

class StatSpeed extends Stat {
	public function new() {
		super(Speed, [Physical(Finesse)]);
	}
}
