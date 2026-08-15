package domain.stats;

class StatHealthRegen extends Stat {
	public function new() {
		super(HealthRegen, [Physical(Resistance)]);
	}
}
