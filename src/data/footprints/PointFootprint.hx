package data.footprints;

import common.struct.IntPoint;
import common.struct.Coordinate;

class PointFootprint implements Footprint {
	public function new() {}

	public function getFootprint(origin: Coordinate, cursor: Coordinate): Array<IntPoint> {
		return [cursor.toWorld().toIntPoint()];
	}
}
