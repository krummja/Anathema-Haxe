package scenes.mainmenu;

import haxe.ui.containers.Box;
import domain.World;
import common.struct.Coordinate;
import common.util.Timeout;
import engine.Frame;
import engine.KeyCode;
import engine.Scene;
import scenes.test.TestScene;

@:xml('
<box width="120px" height="30px">
	<button text="Test!" style="color: #ffffff;" />
</box>
')
class TestButton extends Box {
	private var scene: Scene;

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		this.scene.loop.render(HUD, this);
	}
}

@:xml('
<box width="100%" height="100%">
	<box
		width="100%"
		height="80px"
		verticalAlign="center"
		horizontalAlign="center"
	>
		<label
			text="Anathema"
			width="100%"
			styleName="title"
		/>
	</box>
</box>
')
class MainMenuView extends Box {
	private var scene: Scene;

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		this.scene.loop.render(HUD, this);

		var button = new TestButton(scene);
		addComponent(button);
	}
}

class MainMenuScene extends Scene {
	private var timeout: Timeout;

	private var ui: MainMenuView;
	private var test: TestButton;

	public function new() {
		timeout = new Timeout(3, "mainmenu");
		this.ui = new MainMenuView(this);
	}

	public override function onEnter() {}

	public override function update(frame: Frame) {
		timeout.update();
	}

	public override function onMouseUp(pos: Coordinate) {
		// okay();
	}

	public override function onKeyDown(key: KeyCode) {
		okay();
	}

	public override function onDestroy() {
		this.ui.remove();
	}

	private function okay() {
		var seed = Std.random(0xffffff);
		loop.files.deleteSave("test");
		loop.files.setSaveName("test");
		loop.setWorld(new World());
		loop.world.initialize();
		loop.world.start(seed);
		loop.scenes.set(new TestScene());
	}
}
