package scenes.mainmenu;

// Third-Party
import haxe.ui.containers.Box;
import haxe.ui.core.ItemRenderer;
import haxe.ui.events.MouseEvent;
// Internal
import common.struct.Coordinate;
import common.util.Timeout;
import domain.World;
import engine.Frame;
import engine.KeyCode;
import engine.Scene;
import scenes.adventure.AdventureScene;
import scenes.options.OptionsScene;
import scenes.ui.Layouts.GridLayout;

typedef ClickEvent = (e: MouseEvent) -> Void;

@:build(haxe.ui.macros.ComponentMacros.build("res/ui/test.xml"))
class TestItem extends Box {
	public function new(scene: Scene) {
		super();
		scene.loop.render(HUD, this);

		trace(test);
	}
}

@:xml('
<box>
	<style>
	.itemRender {
		width: 100%;
	}

	.itemRender2 {
		width: 100%;
		text-align: right;
		color: #ff0000;
		font-size: 10px;
	}
	</style>
	<section-header text="Section" />
	<accordion id="acc1" width="400" height="400">
		<vbox text="Subsection" width="100%">
			<listview width="100%" height="100%">
				<item-renderer layout="horizontal" width="100%">
					<hbox width="100%">
						<label id="title" styleName="itemRender" />
						<label id="test" styleName="itemRender2" />
					</hbox>
				</item-renderer>
				<data>
					<item title="foo" test="foo" />
					<item title="bar" test="bar" />
					<item title="baz" test="bar" />
				</data>
			</listview>
		</vbox>
		<vbox text="Subsection 2" width="100%">
			<listview width="100%" height="100%">
				<data>
					<item text="foo" />
					<item text="bar" />
					<item text="baz" />
				</data>
			</listview>
		</vbox>
	</accordion>
</box>
')
class CustomItem extends Box {
	public function new(scene: Scene) {
		super();
		scene.loop.render(HUD, this);
	}
}

@:xml('
<box width="100%" height="100%">
    <style>
        .root {
            width: 100%;
            height: 100%;
            padding: 8px;
        }

        .root .root-item {
            width: 100%;
            height: 120px;
        }

        #title {
            horizontal-align: center;
			height: 40%;
        }

        #menu-wrapper {
            height: 60%;
			width: 100%;
		}

		#menu {
			height: 100%;
			width: 100%;
		}

		.menu-item {
			width: 200px;
			horizontal-align: center;
		}
    </style>

    <vbox styleName="root">
        <box id="title" styleName="root-item">
			<label text="Anathema" styleName="title" />
		</box>
        <box id="menu-wrapper" styleName="root-item">
            <vbox horizontalAlign="center" verticalAlign="center">
                <button id="start" styleName="menu-item" text="Start" />
                <button id="options" styleName="menu-item" text="Options" />
                <button id="quit" styleName="menu-item" text="Quit" />
            </vbox>
        </box>
    </vbox>
</box>
')
class MainMenuView extends Box {
	public var onStartClick(default, set): ClickEvent;
	public var onOptionsClick(default, set): ClickEvent;
	public var onQuitClick(default, set): ClickEvent;

	private var scene: Scene;

	public function new(scene: Scene) {
		super();
		this.scene = scene;
		this.scene.loop.render(HUD, this);
	}

	private function set_onStartClick(value: ClickEvent): ClickEvent {
		start.onClick = value;
		return value;
	}

	private function set_onOptionsClick(value: ClickEvent): ClickEvent {
		options.onClick = value;
		return value;
	}

	private function set_onQuitClick(value: ClickEvent): ClickEvent {
		quit.onClick = value;
		return value;
	}
}

class MainMenuScene extends Scene {
	public function new() {}

	public override function onEnter() {
		var mainMenu = new MainMenuView(this);
		mainMenu.onStartClick = function(e) {
			okay();
		}
		mainMenu.onOptionsClick = function(e) {
			options();
		}
		mainMenu.onQuitClick = function(e) {
			quit();
		}
		this.ui.addComponent(mainMenu);
	}

	public override function onDestroy() {
		this.ui.removeChildren();
		this.ui.remove();
	}

	private function okay() {
		var seed = Std.random(0xffffff);
		loop.files.deleteSave("test");
		loop.files.setSaveName("test");
		loop.setWorld(new World());
		loop.world.initialize();
		loop.world.start(seed);
		loop.scenes.set(new AdventureScene());
	}

	private function options() {
		loop.scenes.push(new OptionsScene());
	}

	private function quit() {
		loop.requestExit();
	}
}
