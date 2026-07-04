package data.save;

typedef ComponentSaveData = {
	var type: String;
	var data: Dynamic;
}

typedef EntitySaveData = {
	var id: String;
	var pos: {
		x: Float,
		y: Float,
	};
	var isDetachable: Bool;
	var isDetached: Bool;
	var components: Array<ComponentSaveData>;
}
