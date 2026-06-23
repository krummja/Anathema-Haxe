package engine;

import hxd.Window;

enum RenderLayerSpace {
	SCREEN;
	WORLD;
}

enum RenderLayerType {
	BACKGROUND;
	GROUND;
	OBJECT;
	ACTOR;
	EFFECT;
	OVERLAY;
	HUD;
	POPUP;
}

/**
 * Wrapper around heaps `h2d.Layers` object.
 */
class RenderLayer {
	public var space(default, null): RenderLayerSpace;
	public var ob(default, null): h2d.Layers;
	public var isVisible(get, set): Bool;

	public function new(space: RenderLayerSpace) {
		this.space = space;
		this.ob = new h2d.Layers();
	}

	private inline function get_isVisible(): Bool {
		return this.ob.visible;
	}

	private inline function set_isVisible(value: Bool): Bool {
		return this.ob.visible = value;
	}
}

class RenderLayerManager {
	/**
	 * Composite of world- and screen-space layers, as well as any additional effects
	 * layers.
	 */
	public var root(default, null): h2d.Layers;

	/**
	 * World-space layers.
	 */
	public var scroller(default, null): h2d.Layers;

	/**
	 * Screen-space layers
	 */
	public var screen(default, null): h2d.Layers;

	public var background: h2d.Bitmap;

	private var scrollerCount: Int = 0;
	private var screenCount: Int = 0;
	private var layers: Map<RenderLayerType, RenderLayer>;

	public function new() {
		this.root = new h2d.Layers();

		this.background = new h2d.Bitmap(h2d.Tile.fromColor(0x212121));
		this.background.width = Window.getInstance().width;
		this.background.height = Window.getInstance().height;

		Window.getInstance().addResizeEvent(() -> {
			this.background.width = Window.getInstance().width;
			this.background.height = Window.getInstance().height;
		});

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

		this.root.addChildAt(this.background, 0);
		this.root.addChildAt(this.scroller, 1);
		this.root.addChildAt(this.screen, 2);
	}

	public function createLayer(type: RenderLayerType, space: RenderLayerSpace): RenderLayer {
		var layer = new RenderLayer(space);

		switch layer.space {
			case WORLD:
				this.scroller.add(layer.ob, this.scrollerCount++);
			case SCREEN:
				this.screen.add(layer.ob, this.screenCount++);
		}

		this.layers.set(type, layer);
		return layer;
	}

	public function render(layerType: RenderLayerType, ob: h2d.Object): Void {
		this.layers.get(layerType).ob.addChild(ob);
	}

	public function clear(renderLayer: RenderLayerType): Void {
		this.layers.get(renderLayer).ob.removeChildren();
	}

	public function clearAll(): Void {
		for (layer in this.layers) {
			layer.ob.removeChildren();
		}
	}
}
