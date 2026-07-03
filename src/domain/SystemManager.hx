package domain;

import domain.systems.*;
import engine.Frame;

class SystemManager {
	public var energy(default, null): EnergySystem;
	public var movement(default, null): MovementSystem;
	public var chunks(default, null): ChunkSystem;
	public var sprites(default, null): SpriteSystem;

	public function new() {}

	public function initialize() {
		energy = new EnergySystem();
		movement = new MovementSystem();
		chunks = new ChunkSystem();
		sprites = new SpriteSystem();
	}

	public function update(frame: Frame) {
		energy.update(frame);
		movement.update(frame);
		chunks.update(frame);
		sprites.update(frame);
	}
}
