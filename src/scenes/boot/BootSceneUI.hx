package scenes.boot;

import engine.Frame;
import engine.UIComponent;
import haxe.ui.events.MouseEvent;

@:xml('
<vbox width="100%" height="100%" style="padding: 4px;">
    <hbox>
        <vbox>
            <button id="startButton" text="Start" style="font-size: 20px;" />
        </vbox>
    </hbox>
</vbox>
')
class BootSceneUI extends UIComponent {
	private var scene: BootScene;

	public function new(scene: BootScene) {
		super();
		this.scene = scene;
		startButton.onClick = onStartClick;
	}

	private function onStartClick(evt: MouseEvent) {
		scene.start();
	}

	public function update(frame: Frame) {}
}
