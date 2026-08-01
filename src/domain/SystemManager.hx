package domain;

import domain.systems.*;
import engine.Frame;

class SystemManager {
	public var energy(default, null): EnergySystem;
	public var chunks(default, null): ChunkSystem;
	public var movement(default, null): MovementSystem;
	public var path(default, null): PathFollowSystem;
	public var lights(default, null): LightSystem;
	public var vision(default, null): VisionSystem;
	public var bitmasks(default, null): BitmaskSystem;
	public var sprites(default, null): SpriteSystem;
	public var attack(default, null): AttackSystem;
	public var floatingText(default, null): FloatingTextSystem;
	public var expiring(default, null): ExpiringSystem;
	public var destroy(default, null): DestroySystem;
	public var debug(default, null): DebugSystem;

	public function new() {}

	public function initialize() {
		energy = new EnergySystem();
		chunks = new ChunkSystem();
		movement = new MovementSystem();
		path = new PathFollowSystem();
		lights = new LightSystem();
		vision = new VisionSystem();
		bitmasks = new BitmaskSystem();
		sprites = new SpriteSystem();
		attack = new AttackSystem();
		floatingText = new FloatingTextSystem();
		expiring = new ExpiringSystem();
		destroy = new DestroySystem();
		debug = new DebugSystem();
	}

	public function update(frame: Frame) {
		// death
		energy.update(frame);
		// fuel
		chunks.update(frame);
		movement.update(frame);
		path.update(frame);
		// crush
		lights.update(frame);
		// highlight
		vision.update(frame);
		bitmasks.update(frame);
		sprites.update(frame);
		// projectiles
		// hitBlink
		attack.update(frame);
		// health
		// healthBar
		floatingText.update(frame);
		// storylines
		expiring.update(frame);
		destroy.update(frame);

		debug.update(frame);
	}
}
