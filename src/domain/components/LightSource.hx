package domain.components;

import engine.ColorKey;
import ecs.Component;
import domain.events.EntitySpawnedEvent;

class LightSource extends Component {
	@save public var intensity: Float;
	@save public var range: Int;
	@save public var color: Int;
	@save public var isEnabled(default, set): Bool = true;
	@save public var disableLutShader(default, set): Bool;

	public function new(
		intensity: Float = 0.5,
		color: ColorKey = C_WHITE,
		range: Int = 5,
		isEnabled: Bool = true,
		disableLutShader: Bool = true
	) {
		this.intensity = intensity;
		this.range = range;
		this.color = color.toInt();
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
