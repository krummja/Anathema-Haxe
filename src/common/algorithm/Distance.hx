package common.algorithm;

import common.struct.IntPoint;
import common.struct.FloatPoint;

enum DistanceFormula {
	MANHATTAN;
	DIAGONAL;
	EUCLIDEAN;
	EUCLIDEAN_SQ;
	CHEBYSHEV;
}

class Distance {
	public overload extern inline static function Get(a: FloatPoint, b: FloatPoint, formula: DistanceFormula): Float {
		return switch formula {
			case MANHATTAN:
				return Manhattan(a, b);
			case EUCLIDEAN:
				return Euclidean(a, b);
			case EUCLIDEAN_SQ:
				return EuclideanSq(a, b);
			case CHEBYSHEV:
				return Chebyshev(a, b);
			case DIAGONAL:
				return Diagonal(a, b);
		}
	}

	public overload extern inline static function Get(a: IntPoint, b: IntPoint, formula: DistanceFormula): Float {
		return switch formula {
			case MANHATTAN:
				return Manhattan(a, b);
			case EUCLIDEAN:
				return Euclidean(a, b);
			case EUCLIDEAN_SQ:
				return EuclideanSq(a, b);
			case CHEBYSHEV:
				return Chebyshev(a, b);
			case DIAGONAL:
				return Diagonal(a, b);
		}
	}

	public overload extern inline static function Manhattan(a: FloatPoint, b: FloatPoint): Float {
		return Math.abs(a.x - b.x) + Math.abs(a.y - b.y);
	}

	public overload extern inline static function Chebyshev(a: FloatPoint, b: FloatPoint): Float {
		return Math.floor(Math.max(Math.abs(a.x - b.x), Math.abs(a.y - b.y)));
	}

	public overload extern inline static function EuclideanSq(a: FloatPoint, b: FloatPoint): Float {
		var dx = a.x - b.x;
		var dy = a.y - b.y;
		return dx * dx + dy * dy;
	}

	public overload extern inline static function Euclidean(a: FloatPoint, b: FloatPoint): Float {
		return Math.sqrt(EuclideanSq(a, b));
	}

	public overload extern inline static function Diagonal(a: FloatPoint, b: FloatPoint): Float {
		var dx = Math.abs(a.x - b.x);
		var dy = Math.abs(a.y - b.y);
		return (dx + dy) - (0.59 * Math.min(dx, dy));
	}

	public overload extern inline static function Manhattan(a: IntPoint, b: IntPoint): Int {
		return cast Math.abs(a.x - b.x) + Math.abs(a.y - b.y);
	}

	public overload extern inline static function Chebyshev(a: IntPoint, b: IntPoint): Int {
		return Math.floor(Math.max(Math.abs(a.x - b.x), Math.abs(a.y - b.y)));
	}

	public overload extern inline static function EuclideanSq(a: IntPoint, b: IntPoint): Int {
		var dx = a.x - b.x;
		var dy = a.y - b.y;
		return dx * dx + dy * dy;
	}

	public overload extern inline static function Euclidean(a: IntPoint, b: IntPoint): Int {
		return cast Math.sqrt(EuclideanSq(a, b));
	}

	public overload extern inline static function Diagonal(a: IntPoint, b: IntPoint): Int {
		var dx = Math.abs(a.x - b.x);
		var dy = Math.abs(a.y - b.y);
		return cast((dx + dy) - (0.59 * Math.min(dx, dy)));
	}
}
