package domain.stats;

class StatUnarmed extends Stat {
	public function new() {
		super(
			Unarmed,
			[
				Physical(Power),
				Physical(Finesse),
			]
		);
	}
}
