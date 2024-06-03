package core;


class RenderLayerManager
{
    public var root(default, null): h2d.Layers;
    public var scroller(default, null): h2d.Layers;
    public var screen(default, null): h2d.Layers;

    private var scrollerCount: Int = 0;
    private var screenCount: Int = 0;
    private var layers: Map<RenderLayerType, RenderLayer>;

    public function new()
    {
        this.root = new h2d.Layers();
        this.scroller = new h2d.Layers();
        this.screen = new h2d.Layers();
        this.layers = new Map();

        this.createLayer(BACKGROUND, WORLD);
        this.createLayer(GROUND, WORLD);
        this.createLayer(OBJECT, WORLD);
        this.createLayer(ACTOR, WORLD);
        this.createLayer(EFFECT, WORLD);
        this.createLayer(OVERLAY, WORLD);
        this.createLayer(HUD, SCREEN);
        this.createLayer(POPUP, SCREEN);

        // this.root.addChildAt(background, 0);
        this.root.addChildAt(scroller, 1);
        this.root.addChildAt(screen, 2);
    }

    public function createLayer(type: RenderLayerType, space: RenderLayerSpace): RenderLayer
    {
        var layer = new RenderLayer(space);

        switch layer.space
        {
            case WORLD:
                this.scroller.add(layer.ob, this.scrollerCount++);
            case SCREEN:
                this.scroller.add(layer.ob, screenCount++);
        }

        this.layers.set(type, layer);
        return layer;
    }

    public function render(layerType: RenderLayerType, ob: h2d.Object): Void
    {
        this.layers.get(layerType).ob.addChild(ob);
    }

    public function clear(renderLayer: RenderLayerType): Void
    {
        this.layers.get(renderLayer).ob.removeChildren();
    }

    public function clearAll(): Void
    {
        this.layers.each((layer) -> layer.ob.removeChildren());
    }
}
