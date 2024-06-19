package data;


enum abstract Cardinal(Int) from Int to Int
{
    public static var values(get, never): Array<Cardinal>;

    public static function fromRadians(radians: Float): Cardinal
    {
        var val = (radians / (Math.PI / 4)).round();

        return switch val
        {
            case 0: EAST;
            case 1: SOUTH_EAST;
            case 2: SOUTH;
            case 3: SOUTH_WEST;
            case 4: WEST;
            case 5: NORTH_WEST;
            case 6: NORTH;
            case 7: NORTH_EAST;
            case _: EAST;
        }
    }

    public static function fromDegrees(degrees: Float): Cardinal
    {
        var val: Float = (degrees / 45.0).round();

        return switch val
        {
            case 0: EAST;
            case 1: SOUTH_EAST;
            case 2: SOUTH;
            case 3: SOUTH_WEST;
            case 4: WEST;
            case 5: NORTH_WEST;
            case 6: NORTH;
            case 7: NORTH_EAST;
            case _: EAST;
        }
    }

    private static function get_values(): Array<Cardinal>
    {
        return [NORTH, NORTH_EAST, EAST, SOUTH_EAST, SOUTH, SOUTH_WEST, WEST, NORTH_WEST];
    }

    var NORTH = 0;
    var NORTH_EAST = 1;
    var EAST = 2;
    var SOUTH_EAST = 3;
    var SOUTH = 4;
    var SOUTH_WEST = 5;
    var WEST = 6;
    var NORTH_WEST = 7;

    @:to
    public function toInt(): Int
    {
        return this;
    }
}
