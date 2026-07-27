package data.footprints;

import common.struct.IntPoint;
import common.struct.Coordinate;

interface Footprint {
	public function getFootprint(origin: Coordinate, cursor: Coordinate): Array<IntPoint>;
}
