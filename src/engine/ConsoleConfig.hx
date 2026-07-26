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
	}

	private static function get_loop(): MainLoop {
		return MainLoop.getInstance();
	}
}
