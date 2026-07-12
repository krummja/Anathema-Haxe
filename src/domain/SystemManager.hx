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
	public var expiring(default, null): ExpiringSystem;
	public var destroy(default, null): DestroySystem;

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
		expiring = new ExpiringSystem();
		destroy = new DestroySystem();
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
		// bumpAttack
		// health
		// healthBar
		// floatingText
		// storylines
		expiring.update(frame);
		destroy.update(frame);
	}
}
