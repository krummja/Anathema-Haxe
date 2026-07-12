package domain.components;

import common.struct.IntPoint;
import ecs.Component;

class Path extends Component {
	@save private var instructions: Array<IntPoint>;
	@save private var curIdx: Int;

	public var length(get, never): Int;
	public var remaining(get, never): Int;
	public var current(get, never): IntPoint;

	public function new(instructions: Array<IntPoint>) {
		this.instructions = instructions;
		curIdx = 0;
	}

	public function next(): IntPoint {
		curIdx++;
		return current;
	}

	public function hasNext(): Bool {
		return remaining > 0;
	}

	private inline function get_length(): Int {
		return instructions.length;
	}

	private inline function get_current(): IntPoint {
		return instructions[curIdx];
	}

	private inline function get_remaining(): Int {
		return (length - 1) - curIdx;
	}
}
