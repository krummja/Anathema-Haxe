package domain.prefabs;

import core.ecs.Entity;
import common.struct.Coordinate;


abstract class Prefab
{
    public function new() {}

    public abstract function Create(options: Dynamic, pos: Coordinate): Entity;
}
