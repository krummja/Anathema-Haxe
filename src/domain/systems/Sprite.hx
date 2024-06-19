package domain.systems;

import core.MainLoop;
import domain.components.Drawable;
import domain.components.Sprite;
import core.ecs.Query;


class SpriteSystem extends System
{
    var sprites: Query;

    public function new()
    {
        this.sprites = new Query({
            all: [Sprite],
            none: [],
        });

        this.sprites.onEntityAdded((entity) -> this.renderSprite(entity.get(Sprite)));
        this.sprites.onEntityRemoved((entity) -> this.removeSprite(entity.get(Sprite)));
    }

    private function renderSprite(drawable: Drawable): Void
    {
        if (drawable != null) MainLoop.instance.render(drawable.layer, drawable.drawable);
    }

    private function removeSprite(drawable: Drawable): Void
    {
        if (drawable != null) drawable.drawable.remove();
    }
}
