package core;

import data.Commands;
import common.struct.Queue;


class CommandManager
{
    public var loop(get, null): MainLoop;

    private var queue: Queue<Command>;

    public function new()
    {
        this.queue = new Queue();
    }

    public function hasNext(): Bool
    {
        return this.peek() != null;
    }

    public function peek(): Null<Command>
    {
        if (this.queue.length > 0) return this.queue.peek();
        var commands = Commands.GetForDomain([
            this.loop.scenes.current.inputDomain,
            INPUT_DOMAIN_DEFAULT,
        ]);

        while (this.loop.input.hasNext())
        {
            var event = this.loop.input.peek();
            var input = commands.find((c) -> c.isMatch(event));
            if (input != null) return input;
            this.loop.input.next();
        }

        return null;
    }

    public function next(): Null<Command>
    {
        if (this.queue.length > 0) return this.queue.dequeue();

        var commands = Commands.GetForDomain([
            this.loop.scenes.current.inputDomain,
            INPUT_DOMAIN_DEFAULT,
        ]);

        while (this.loop.input.hasNext())
        {
            var event = this.loop.input.next();
            var input = commands.find((c) -> c.isMatch(event));
            if (input != null) return input;
        }

        return null;
    }

    public function push(command: Command): Void
    {
        this.queue.enqueue(command);
    }

    private function get_loop(): MainLoop
    {
        return MainLoop.instance;
    }
}
