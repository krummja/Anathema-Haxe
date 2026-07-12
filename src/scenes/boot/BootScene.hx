package scenes.boot;

import h3d.Vector4;
import engine.Frame;
import common.struct.Coordinate;
import common.util.Timeout;
import scenes.ui.label.Label;
import scenes.mainmenu.MainMenuScene;
import engine.Scene;
import domain.World;
import engine.KeyCode;

class BootScene extends Scene {
	private var testLabel: Label;
	private var timeout: Timeout;
	private var bootIn: Timeout;
	private var bootOut: Timeout;

	private var splash: Label;
	private var duration: Float = 6;

	public function new() {}

	public override function onEnter() {
		splash = new Label({
			content: "Simulacrum Games",
			pos: {x: camera.width / 2, y: camera.height / 2},
			fontColor: new Vector4(1, 1, 1, 0),
			fontScale: 2,
		});

		timeout = new Timeout(6, "boot");
		bootIn = new Timeout(4, "boot-in");
		bootOut = new Timeout(2, "boot-out", true);
		bootOut.stop();

		bootIn.onComplete = bootOut.reset;
	}

	public override function update(frame: Frame) {
		timeout.update();
		bootIn.update();
		bootOut.update();

		duration -= frame.dt;

		if (duration <= 0) {
			start();
			return;
		}

		var opacity: Float = 0.0;

		if (bootIn.isPlaying) {
			opacity = bootIn.progress.ease(EASE_IN_OUT_SINE);
		} else if (bootOut.isPlaying) {
			opacity = bootOut.progress.ease(EASE_IN_OUT_SINE);
		}

		splash.color = new Vector4(1, 1, 1, opacity);

		var scale = timeout.progress.ease(EASE_LINEAR);
		splash.scale = 2 + scale;
	}

	public override function onMouseUp(pos: Coordinate) {
		start();
	}

	public override function onKeyDown(key: KeyCode) {
		start();
	}

	public function start() {
		loop.scenes.set(new MainMenuScene());

		splash.remove();
		timeout.stop();
		bootIn.stop();
		bootOut.stop();
	}
}
