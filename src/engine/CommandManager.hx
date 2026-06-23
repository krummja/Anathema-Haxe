package engine;

import common.struct.Queue;

@:structInit class Command {
	public var domain: InputDomainType;
	public var type: CommandType;
	public var key: KeyCode;
	public var shift: Bool;
	public var ctrl: Bool;
	public var alt: Bool;

	public var name(get, never): String;

	/**
	 * Check if the `Command` matches the specified `KeyEvent`.
	 */
	public function isMatch(event: KeyEvent): Bool {
		return (key == event.key && shift == event.shift && ctrl == event.ctrl && alt == event.alt);
	}

	public function toString(): String {
		return name;
	}

	public function friendlyKey(): String {
		var val = "";

		if (shift) val += "shift+";
		if (ctrl) val += "ctrl+";
		if (alt) val += "alt+";

		val += key.toChar();

		return val;
	}

	private function get_name(): String {
		return this.type;
	}
}

class CommandManager {
	private var queue: Queue<Command>;

	public function new() {
		this.queue = new Queue();
	}

	public function hasNext(): Bool {
		return this.peek() != null;
	}

	public function peek(): Null<Command> {
		if (this.queue.length > 0)
			return this.queue.peek();

		// Retrieve the commands for the current input domain as well as the default.
		var commands = Commands.getForDomain([
			MainLoop.getInstance().scenes.current.inputDomain,
			INPUT_DOMAIN_DEFAULT,
		]);

		// Peek the queue in the InputManager.
		// While there is an input event on the stack, see if we have a matching Command.
		while (MainLoop.getInstance().input.hasNext()) {
			var event = MainLoop.getInstance().input.peek();

			// If we find a matching command, return it to the caller.
			var command = Lambda.find(commands, (c) -> c.isMatch(event));
			if (command != null)
				return command;

			// Otherwise, discard the event and move to the next one.
			MainLoop.getInstance().input.next();
		}

		return null;
	}

	public function next(): Null<Command> {
		if (this.queue.length > 0)
			return this.queue.dequeue();

		var commands = Commands.getForDomain([
			MainLoop.getInstance().scenes.current.inputDomain,
			INPUT_DOMAIN_DEFAULT,
		]);

		while (MainLoop.getInstance().input.hasNext()) {
			var event = MainLoop.getInstance().input.next();
			var input = Lambda.find(commands, (c) -> c.isMatch(event));
			if (input != null)
				return input;
		}

		return null;
	}

	public function push(command: Command): Void {
		this.queue.enqueue(command);
	}
}
