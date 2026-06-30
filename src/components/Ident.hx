package components;

class Ident extends Component {
	public var value(default, null): String;

	public function new(?value: String) {
		this.value = value;
	}
}
