package domain.systems;

import engine.Frame;
import engine.MainLoop;
import common.util.Colors;
import common.struct.IntPoint;
import common.algorithm.Shadowcast;
import shaders.SpriteShader;
import domain.components.*;
import ecs.Query;
import ecs.System;

typedef LightFragment = {
	pos: IntPoint,
	distance: Float,
	intensity: Float,
	color: Int,
	source: IntPoint,
	sourceId: String,
}

typedef TileLightData = {
	intensity: Float,
	color: Int,
}

class LightSystem extends System {
	public var query: Query;

	public var lightFragments: Map<Int, Array<LightFragment>> = [];

	private var litTiles: Map<Int, TileLightData> = [];
	private var flagRecompute: Bool = false;
	private var darkTile: TileLightData = {
		intensity: 0,
		color: 0,
	};

	public function new() {
		query = new Query({
			all: [LightSource],
			none: [IsDestroyed],
		});

		query.onEntityRemoved((e) -> {
			flagRecompute = true;
		});
	}

	public override function update(frame: Frame) {
		if (world.clock.tickDelta <= 0 && !flagRecompute) {
			return;
		}

		flagRecompute = false;

		clearLitTiles();

		for (entity in query) {
			var light = entity.get(LightSource);

			if (!light.isEnabled) {
				continue;
			}

			Shadowcast.compute({
				start: entity.pos.toIntPoint(),
				distance: light.range,
				isBlocker: (p) -> {
					if (world.isOutOfBounds(p)) {
						return false;
					}
					var entities = world.getEntitiesAt(p.asWorld().toIntPoint());
					return Lambda.exists(entities, (e) -> e.has(LightBlocker));
				},
				onLight: (pos, distance) -> {
					var d = distance > 0.75 ? distance = 0.75 : 0.75;
					var i = light.intensity / (d * d);

					addFragment({
						pos: pos,
						intensity: i,
						distance: d,
						color: light.color,
						source: entity.pos.toIntPoint(),
						sourceId: Std.string(entity.id),
					});
				}
			});
		}

		applyLights();
	}

	public function getTileLight(pos: IntPoint): Null<TileLightData> {
		var idx = world.getTileIdx(pos);
		return litTiles.get(idx).or(darkTile);
	}

	public function clearLitTiles() {
		for (idx in lightFragments.keys()) {
			var pos = world.getTilePos(idx);
			var shader = getShader(pos);
			if (shader != null) {
				shader.isLit = 0;
			}
		}

		litTiles = [];
		lightFragments = [];
	}

	private function addFragment(fragment: LightFragment): Void {
		var idx = world.getTileIdx(fragment.pos);
		var existing = lightFragments.get(idx);
		if (existing == null) {
			lightFragments.set(idx, [fragment]);
		} else {
			var isDuplicate = Lambda.exists(existing, (f) -> f.sourceId == fragment.sourceId);
			if (!isDuplicate) {
				existing.push(fragment);
			}
		}
	}

	private function combine(fragments: Array<LightFragment>): TileLightData {
		var color: Int = -1;
		var intensity = fragments.sum((f) -> f.intensity);

		for (fragment in fragments) {
			if (color <= 0) {
				color = fragment.color;
			} else {
				color = Colors.mix(color, fragment.color, fragment.intensity / intensity);
			}
		}

		return {
			color: color,
			intensity: intensity.clamp(0, 1),
		};
	}

	private function applyLights() {
		var world = MainLoop.getInstance().world;

		var walls: Map<Int, Array<LightFragment>> = new Map();
		var floors: Map<Int, Array<LightFragment>> = new Map();

		for (idx => fragmentList in lightFragments) {
			var pos = world.getTilePos(idx);
			var shader = getShader(pos);
			var entities = world.getEntitiesAt(pos);

			// Add fragment to walls map if has LightBlocker
			if (Lambda.exists(entities, (e) -> e.has(LightBlocker))) {
				walls.set(idx, fragmentList);
				continue;
			}

			// All other tiles are processed as floor
			floors.set(idx, fragmentList);

			if (shader != null) {
				var compiled = combine(fragmentList);
				shader.lightColor = compiled.color.toHxdColor().toVector();
				shader.lightIntensity = compiled.intensity.clamp(0, 1);
				shader.isLit = 1;
				litTiles.set(idx, {
					intensity: compiled.intensity,
					color: compiled.color,
				});
			}
		}

		var pov = world.player.entity.pos.toWorld().toIntPoint();

		for (idx => fragmentList in walls) {
			var pos = world.getTilePos(idx);
			var offset = pov.sub(pos).toCardinal().toOffset();
			var offsetTile = pos.add(offset);
			var offsetTileIdx = world.getTileIdx(offsetTile);
			var floorAtOffset = floors.get(offsetTileIdx);
			var validFragments: Array<LightFragment> = [];
			var color: Int = -1;
			var intensity: Float = 0;

			if (floorAtOffset == null) {
				continue;
			}

			for (fragment in fragmentList) {
				var hasLitFloor = Lambda.exists(floorAtOffset, (f) -> {
					return f.sourceId == fragment.sourceId;
				});

				if (!hasLitFloor) {
					continue;
				}

				intensity += fragment.intensity;
				validFragments.push(fragment);
			}

			for (fragment in validFragments) {
				if (color <= 0) {
					color = fragment.color;
				} else {
					color = Colors.mix(color, fragment.color, fragment.intensity / intensity);
				}
			}

			var shader = getShader(pos);

			if (shader != null) {
				var outIntensity = intensity.clamp(0, 1);
				shader.lightColor = color.toHxdColor().toVector();
				shader.lightIntensity = outIntensity;
				shader.isLit = 1;

				litTiles.set(idx, {
					intensity: outIntensity,
					color: color,
				});
			}
		}
	}

	private function getShader(pos: IntPoint): SpriteShader {
		var w = pos.asWorld();
		var chunkIdx = w.toChunkId();
		var chunk = world.chunks.getChunkById(chunkIdx);

		if (chunk == null || !chunk.isLoaded) {
			return null;
		}

		var chunkLocal = w.toChunkLocal().toIntPoint();
		var bm = chunk.bitmaps.get(chunkLocal.x, chunkLocal.y);

		if (bm == null) {
			return null;
		}

		return bm.getShader(SpriteShader);
	}
}
