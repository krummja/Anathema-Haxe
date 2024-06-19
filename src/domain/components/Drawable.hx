package domain.components;

import core.ecs.Component;
import core.RenderLayerType;

import data.ColorKey;
import shaders.SpriteShader;


abstract class Drawable extends Component
{
    public var primary(default, set): ColorKey;
    public var secondary(default, set): ColorKey;
    public var outline(default, set): ColorKey;
    public var background(default, set): Null<ColorKey>;
    public var enableLutShader(default, set): Bool = true;

    public var layer(default, null): RenderLayerType;
    public var primaryColor(get, never): ColorKey;
    public var secondaryColor(get, never): ColorKey;
    public var drawable(get, never): h2d.Drawable;
    public var shader(default, null): SpriteShader;

    public var offsetX(default, set): Float = 0;
    public var offsetY(default, set): Float = 0;

    public function new(primary = C_WHITE, secondary = C_CLEAR, layer = OBJECT)
    {
        this.shader = new SpriteShader();
        this.layer = layer;
        this.primary = primary;
        this.secondary = secondary;
    }

    public function updatePosition(px: Float, py: Float): Void
    {
        this.drawable.x = px;
        this.drawable.y = py;
    }

    private abstract function getDrawable(): h2d.Drawable;

    private function set_primary(value: ColorKey): ColorKey
    {
        this.primary = value;
        this.shader.primary = value.toHxdColor();
        return value;
    }

    private function set_secondary(value: ColorKey): ColorKey
    {
        this.secondary = value;
        this.shader.secondary = value.toHxdColor();
        return value;
    }

    private function set_outline(value: ColorKey): ColorKey
    {
        this.outline = value;
        this.shader.outline = value.toHxdColor();
        return value;
    }

    private function set_background(value: Null<ColorKey>): Null<ColorKey>
    {
        this.background = value;
        var clear = value != null;
        if (clear) this.shader.background = value.toHxdColor();
        this.shader.clearBackground = clear ? 1 : 0;
        return value;
    }

    private function set_offsetX(value: Float): Float
    {
        this.offsetX = value;
        this.drawable.x += this.offsetX;
        this.drawable.x -= value;
        return value;
    }

    private function set_offsetY(value: Float): Float
    {
        this.offsetY = value;
        this.drawable.y += this.offsetY;
        this.drawable.y -= value;
        return value;
    }

    private function get_primaryColor(): ColorKey
    {
        return this.primary;
    }

    private function get_secondaryColor(): ColorKey
    {
        return this.secondary;
    }

    private function get_drawable(): h2d.Drawable
    {
        return this.getDrawable();
    }

    private function set_enableLutShader(value: Bool): Bool
    {
        this.enableLutShader = value;
        this.shader.enableLut = value ? 1 : 0;
        return value;
    }
}
