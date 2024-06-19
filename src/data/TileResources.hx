package data;

import h2d.Tile;


class TileResources
{
    public static var tiles: Map<TileKey, Tile> = [];

    public static function Get(key: TileKey): Tile
    {
        if (key.isNull()) return null;
        var tile = tiles.get(key);

        if (tile.isNull()) return tiles.get(TK_UNKNOWN);
        return tile;
    }

    public static function Init()
    {
        var sheet = hxd.Res.tiles.kenny2;
        var t = sheet.toTile().divide(48, 22);

        tiles.set(TK_UNKNOWN, t[0][0]);

        tiles.set(TK_STONES_1, t[0][1]);
        tiles.set(TK_STONES_2, t[0][2]);
        tiles.set(TK_STONES_3, t[0][3]);
        tiles.set(TK_STONES_4, t[0][4]);

        tiles.set(TK_GRASS_1, t[0][5]);
        tiles.set(TK_GRASS_2, t[0][6]);
        tiles.set(TK_GRASS_3, t[0][7]);
        tiles.set(TK_GRASS_4, t[2][0]);

        tiles.set(TK_TREE_1, t[1][0]);
        tiles.set(TK_TREE_2, t[1][1]);
        tiles.set(TK_TREE_3, t[1][2]);
        tiles.set(TK_TREE_4, t[1][3]);
        tiles.set(TK_TREE_5, t[1][4]);
        tiles.set(TK_TREE_6, t[1][5]);
        tiles.set(TK_TREE_7, t[2][3]);
        tiles.set(TK_TREE_8, t[2][4]);

        tiles.set(TK_ROCKS_1, t[2][5]);

        tiles.set(TK_LIL_GUY_1, t[0][25]);
    }
}
