package domain.stats;

class StatDodge extends Stat {
	public function new() {
		super(Dodge, [Physical(Finesse)]);
	}
}
