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
        var t = sheet.toTile().divide(16, 16);

        tiles.set(TK_UNKNOWN, t[0][0]);

        tiles.set(TK_STONES_1, t[1][0]);
        tiles.set(TK_STONES_2, t[2][0]);
        tiles.set(TK_STONES_3, t[3][0]);
        tiles.set(TK_STONES_4, t[4][0]);

        tiles.set(TK_GRASS_1, t[5][0]);
        tiles.set(TK_GRASS_2, t[6][0]);
        tiles.set(TK_GRASS_3, t[7][0]);
        tiles.set(TK_GRASS_4, t[0][2]);

        tiles.set(TK_TREE_1, t[0][1]);
        tiles.set(TK_TREE_2, t[1][1]);
        tiles.set(TK_TREE_3, t[2][1]);
        tiles.set(TK_TREE_4, t[3][1]);
        tiles.set(TK_TREE_5, t[4][1]);
        tiles.set(TK_TREE_6, t[5][1]);
        tiles.set(TK_TREE_7, t[3][2]);
        tiles.set(TK_TREE_8, t[4][2]);

        tiles.set(TK_ROCKS_1, t[5][2]);
    }
}
