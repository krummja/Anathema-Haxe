package core;


/**
 * Wrapper around heaps `h2d.Layers` object.
 *
 * Uses `RenderLayerSpace` enum to provide metadata that can be leveraged in coordinate
 * and projection calculations.
 */
class RenderLayer
{
    public var space(default, null): RenderLayerSpace;
    public var ob(default, null): h2d.Layers;
    public var isVisible(get, set): Bool;

    public function new(space: RenderLayerSpace)
    {
        this.space = space;
        this.ob = new h2d.Layers();
    }

    private inline function get_isVisible(): Bool
    {
        return this.ob.visible;
    }

    private inline function set_isVisible(value: Bool): Bool
    {
        return this.ob.visible = value;
    }
}
