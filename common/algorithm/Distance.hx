package common.algorithm;

import common.struct.FloatPoint;


enum DistanceFormula
{
    // MANHATTAN;
    // DIAGONAL;
    EUCLIDEAN;
    EUCLIDEAN_SQ;
    // CHEBYSHEV;
}

class Distance
{
    public overload extern inline static function Get(a: FloatPoint, b: FloatPoint, formula: DistanceFormula): Float
    {
        return switch formula
        {
            case EUCLIDEAN:
                return Euclidean(a, b);
            case EUCLIDEAN_SQ:
                return EuclideanSq(a, b);
        }
    }

    public overload extern inline static function EuclideanSq(a: FloatPoint, b: FloatPoint): Float
    {
        var dx = a.x - b.x;
        var dy = a.y - b.y;
        return dx * dx + dy * dy;
    }

    public overload extern inline static function Euclidean(a: FloatPoint, b: FloatPoint): Float
    {
        return Math.sqrt(EuclideanSq(a, b));
    }
}
