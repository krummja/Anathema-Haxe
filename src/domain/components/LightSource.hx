package domain.components;

import ecs.Component;
import ecs.Entity;
import domain.events.EntitySpawnedEvent;

class LightSource extends Component {
	public var intensity: Float;
	public var range: Int;
	public var color: Int;
	public var isEnabled(default, set): Bool = true;
	public var disableLutShader(default, set): Bool;

	public function new(
		intensity: Float = 0.5,
		color: Int = 0xffffff,
		range: Int = 5,
		isEnabled: Bool = true,
		disableLutShader: Bool = true
	) {
		this.intensity = intensity;
		this.range = range;
		this.color = color;
		this.isEnabled = isEnabled;
		this.disableLutShader = disableLutShader;

		addHandler(EntitySpawnedEvent, onEntitySpawned);
	}

	private function onEntitySpawned(evt: EntitySpawnedEvent): Void {
		updateShader();
	}

	private function updateShader(): Void {
		var sprite = entity.get(Sprite);
		if (sprite != null) {
			sprite.enableLutShader = !disableLutShader;
		}
	}

	private function set_isEnabled(value: Bool): Bool {
		return value;
	}

	private function set_disableLutShader(value: Bool): Bool {
		return value;
	}
}
