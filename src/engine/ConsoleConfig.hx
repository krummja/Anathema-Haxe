package engine;

import engine.CommandManager;
import h2d.Console;

class ConsoleConfig {
	public static var loop(get, never): MainLoop;

	public static function config(console: Console): Void {
		console.log('Type "help" for a list of commands');

		console.addCommand('exit', 'Close the console', [], () -> {
			loop.scenes.pop();
		});

		console.addCommand('cmds', 'List available commands on current screen', [], () -> {
			console.log('Available commands');
			Commands.getForDomain([INPUT_DOMAIN_DEFAULT, loop.scenes.previous.inputDomain]).each((cmd: Command) -> {
				console.log('${cmd.friendlyKey()} - ${cmd.name}');
			});
		});

		console.addCommand('viewport', 'Manipulate the viewport', [
			{name: "param", t: AEnum(["x", "y", "w", "h", "ax", "ay", "clip"]), opt: true},
			{name: "value", t: AFloat, opt: true},
		], (?param: String, ?value: Float) -> {
			if (param != null) {
				switch (param) {
					case "x":
						if (value != null) {
							loop.camera.viewport.viewportX = value;
						}
						console.log('${loop.camera.viewport.viewportX}');
					case "y":
						if (value != null) {
							loop.camera.viewport.viewportY = value;
						}
						console.log('${loop.camera.viewport.viewportY}');
					case "w":
						if (value != null) {
							loop.camera.viewport.viewportWidth = value;
						}
						console.log('${loop.camera.viewport.viewportWidth}');
					case "h":
						if (value != null) {
							loop.camera.viewport.viewportHeight = value;
						}
						console.log('${loop.camera.viewport.viewportHeight}');
					case "ax":
						if (value != null) {
							loop.camera.viewport.anchorX = value;
						}
						console.log('${loop.camera.viewport.anchorX}');
					case "ay":
						if (value != null) {
							loop.camera.viewport.anchorY = value;
						}
						console.log('${loop.camera.viewport.anchorY}');
					case "clip":
						loop.camera.viewport.clip = !loop.camera.viewport.clip;
						console.log('Viewport clipping toggled [${loop.camera.viewport.clip}]');

						if (value != null) {
							console.log("'clip' takes no arguments");
						}
					case _:
						console.log('Unknown parameter');
				}
			} else {
				console.log("Viewport data:");
				console.log('x ..... ${loop.camera.viewport.viewportX}');
				console.log('y ..... ${loop.camera.viewport.viewportY}');
				console.log('w ..... ${loop.camera.viewport.viewportWidth}');
				console.log('h ..... ${loop.camera.viewport.viewportHeight}');
				console.log('ax .... ${loop.camera.viewport.anchorX}');
				console.log('ay .... ${loop.camera.viewport.anchorY}');
				console.log('clip .. ${loop.camera.viewport.clip}');
			}
		});
	}

	private static function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}
}
