package systems;

import common.algorithm.Shadowcast;
import common.struct.IntPoint;
import common.algorithm.Bresenham;
import common.algorithm.Distance;
import common.struct.Set;
import common.struct.Coordinate;
import echoes.Entity;
import engine.Frame;
import echoes.View;
import systems.System.Query;
import components.*;

class VisionSystem extends System {
	public var visible(get, never): Query;
	public var vis(get, never): Query;
	public var shrouded(get, never): Query;

	public var flagRecompute: Bool;

	private var _visible = getLinkedView(Visible);
	private var _explored = getLinkedView(Explored);

	@:add
	public function onVisibleAdded(vision: Visible, entity: Entity) {
		visEntityAdded(entity);
	}

	@:remove
	public function onVisibleRemoved(vision: Visible, entity: Entity) {
		visEntityRemoved(entity);
	}

	@:add
	public function onExploredAdded(explored: Explored, entity: Entity) {
		visEntityAdded(entity);
	}

	@:remove
	public function onExploredRemoved(explored: Explored, entity: Entity) {
		visEntityRemoved(entity);
	}

	@:update
	public function update(time: Float) {
		if (world.clock.tickDelta > 0 || flagRecompute) {
			computeVision();
		}
	}

	public function initialize() {
		computeVision();
	}

	public function canSee(entity: Entity, target: Coordinate): Bool {
		var vision = entity.get(Vision);

		if (vision == null) {
			return false;
		}

		var a = entity.getPosition().toIntPoint();
		var b = target.toWorld().toIntPoint();
		var distance = Math.round(Distance.Euclidean(a, b));

		if (distance > vision.range) {
			return false;
		}

		if (distance > getVisionRange(entity)) {
			var light = world.systems.getSystem(ON_UPDATE, LightSystem).getTileLight(b);
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
		return vision.range;
	}

	public function computeVision() {
		for (entity in visible) {
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
					var light = world.systems.getSystem(ON_UPDATE, LightSystem).getTileLight(pos);
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
		return Lambda.exists(entities, (e) -> e.exists(LightBlocker));
	}

	private function visEntityAdded(entity: Entity) {
		var light = world.systems.getSystem(ON_UPDATE, LightSystem).getTileLight(entity.getPosition().toIntPoint());

		var sprite = entity.get(Sprite);
		sprite.visible = true;

		if (light.intensity > 0) {
			sprite.shader.isLit = 1;
			sprite.shader.lightColor = light.color.toHxdColor().toVector();
			sprite.shader.lightIntensity = light.intensity;
		} else {
			sprite.shader.isLit = 0;
		}

		flagRecompute = true;
	}

	private function visEntityRemoved(entity: Entity) {
		var sprite = entity.get(Sprite);

		sprite.visible = false;
		sprite.shader.isLit = 0;

		flagRecompute = true;
	}

	private function get_visible(): Query {
		return _visible.entities.filter((e) -> !e.exists(IsDestroyed));
	}

	private function get_vis(): Query {
		var _any = SetTools.fromIterables([_visible.entities, _explored.entities]);
		return _any.asArray().filter((e) -> !e.exists(IsDestroyed));
	}

	private function get_shrouded(): Query {
		return _explored.entities.filter((e) -> !e.exists(Visible) && !e.exists(IsDestroyed));
	}
}
