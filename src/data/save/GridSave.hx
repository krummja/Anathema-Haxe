package data.save;

@:generic
typedef GridSave<T> = {
	var width: Int;
	var height: Int;
	var data: Array<T>;
}
