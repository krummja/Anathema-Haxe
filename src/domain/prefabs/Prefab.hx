package domain.prefabs;

import common.struct.Coordinate;
import ecs.Entity;

abstract class Prefab {
	public function new() {}

	public abstract function create(options: Dynamic, pos: Coordinate): Entity;
}
