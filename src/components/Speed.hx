package components;

class Speed extends Component {
	public var value: Float = 0.0;

	public function new(value: Float) {
		this.value = value;
	}

	public function set(value: Float): Void {
		this.value = value;
	}
}
