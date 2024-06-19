package domain.components;

import core.ecs.EntityEvent;
import data.TileResources;
import h2d.Tile;
import h2d.Bitmap;
import data.TileKey;
import core.RenderLayerType;
import data.ColorKey;


class Sprite extends Drawable
{
    public var tileKey(default, set): TileKey;

    public var ob(default, null): Bitmap;
    public var tile(get, never): Tile;

    public function new(tileKey: TileKey, primary = C_WHITE, secondary = C_BLACK, layer = OBJECT)
    {
        super(primary, secondary, layer);
        this.tileKey = tileKey;

        this.ob = new Bitmap(this.tile);
        this.ob.addShader(this.shader);
        this.ob.visible = true;
    }

    public function on_entitySpawned(event: EntityEvent): EntityEvent
    {
        if (this.entity.has(Position))
        {
            var pos = this.entity.get(Position);
            this.updatePosition(pos.x, pos.y);
        }

        return event;
    }

    private function get_tile(): Tile
    {
        return TileResources.Get(this.tileKey);
    }

    private function set_tileKey(value: TileKey): TileKey
    {
        this.tileKey = value;
        if (this.ob != null) this.ob.tile = this.tile;
        return value;
    }

    private function getDrawable(): h2d.Drawable
    {
        return this.ob;
    }
}
