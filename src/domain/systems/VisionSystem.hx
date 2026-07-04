package domain.systems;

import common.algorithm.Shadowcast;
import common.struct.IntPoint;
import common.algorithm.Bresenham;
import common.algorithm.Distance;
import common.struct.Coordinate;
import engine.Frame;
import ecs.Query;
import ecs.Entity;
import ecs.System;
import domain.components.*;

class VisionSystem extends System {
	var visibles: Query;

	public var flagRecompute: Bool;

	public function new() {
		visibles = new Query({
			all: [Visible],
			none: [IsDestroyed],
		});

		var vis = new Query({
			any: [Visible, Explored],
			none: [IsDestroyed],
		});

		vis.onEntityAdded((entity) -> {
			var light = world.systems.lights.getTileLight(entity.pos.toIntPoint());

			if (entity.has(Sprite)) {
				var sprite = entity.get(Sprite);
				sprite.visible = true;

				if (light.intensity > 0) {
					sprite.shader.isLit = 1;
					sprite.shader.lightColor = light.color.toHxdColor().toVector();
					sprite.shader.lightIntensity = light.intensity;
				} else {
					sprite.shader.isLit = 0;
				}
			}

			flagRecompute = true;
		});

		vis.onEntityRemoved((entity) -> {
			if (entity.has(Sprite)) {
				var sprite = entity.get(Sprite);

				sprite.visible = false;
				sprite.shader.isLit = 0;
			}

			flagRecompute = true;
		});

		var shrouded = new Query({
			all: [Explored],
			none: [Visible, IsDestroyed],
		});

		shrouded.onEntityAdded((entity) -> {
			if (entity.has(Sprite)) {
				var sprite = entity.get(Sprite);

				sprite.isShrouded = true;
				sprite.shader.isLit = 0;

				if (entity.has(Energy)) {
					sprite.visible = false;
				}
			}
		});

		shrouded.onEntityRemoved((entity) -> {
			if (entity.has(Sprite)) {
				var sprite = entity.get(Sprite);

				sprite.isShrouded = false;

				if (entity.has(Energy)) {
					sprite.visible = true;
				}
			}
		});
	}

	public function initialize() {
		computeVision();
	}

	public override function update(frame: Frame) {
		if (world.clock.tickDelta > 0 || flagRecompute) {
			computeVision();
		}
	}

	public function canSee(source: Entity, target: Coordinate): Bool {
		var vision = source.get(Vision);

		if (vision == null) {
			return false;
		}

		var a = source.pos.toIntPoint();
		var b = target.toWorld().toIntPoint();
		var distance = Math.round(Distance.Euclidean(a, b));

		if (distance > vision.range) {
			return false;
		}

		if (distance > getVisionRange(source)) {
			var light = world.systems.lights.getTileLight(b);
			if (light.intensity <= 0) {
				return false;
			}
		}

		var isVisible = true;

		Bresenham.stroke(a, b, (p) -> {
			if (isBlocker(p)) {
				isVisible = false;
			}
		});

		return isVisible;
	}

	public function getVisionRange(entity: Entity): Int {
		var vision = world.player.entity.get(Vision);
		return (world.clock.getDaylight() * vision.range).round();
	}

	public function computeVision() {
		for (entity in visibles) {
			entity.remove(Visible);
		}

		world.clearVisible();

		var vision = world.player.entity.get(Vision);
		var range = getVisionRange(world.player.entity);

		Shadowcast.compute({
			start: world.player.pos.toIntPoint(),
			distance: vision.range,
			isBlocker: isBlocker,
			onLight: (pos, distance) -> {
				if (distance > range) {
					var light = world.systems.lights.getTileLight(pos);
					if (light.intensity > 0) {
						world.setVisible(pos.asWorld());
					}
				} else {
					world.setVisible(pos.asWorld());
				}
			}
		});

		flagRecompute = true;
	}

	private function isBlocker(p: IntPoint) {
		if (world.isOutOfBounds(p)) {
			return false;
		}

		var entities = world.getEntitiesAt(p.asWorld().toIntPoint());
		return Lambda.exists(entities, (e) -> e.has(LightBlocker));
	}
}
