package engine;

import haxe.macro.Context;
import haxe.macro.Expr;
import echoes.View;
import echoes.System;
import components.Component;

typedef QueryFilter = {
	?any: Array<Class<Component>>,
	?all: Array<Class<Component>>,
	?none: Array<Class<Component>>,
}

class Query {
	private static var any: Array<Class<Component>>;
	private static var all: Array<Class<Component>>;
	private static var none: Array<Class<Component>>;

	public static macro function build(alias: String, filter: QueryFilter): Array<Field> {
		var fields = Context.getBuildFields();

		var value = 1.5;

		var getterFunc: Function = {
			expr: macro return $v{value},
			ret: (macro : Float),
			args: [],
		};

		var property: Field = {
			name: alias,
			access: [Access.APublic],
			kind: FieldType.FProp("get", "null", getterFunc.ret),
			pos: Context.currentPos(),
		};

		var getter: Field = {
			name: "get_" + alias,
			access: [Access.APrivate, Access.AInline],
			kind: FieldType.FFun(getterFunc),
			pos: Context.currentPos(),
		};

		fields.push(property);
		fields.push(getter);

		return fields;
	}
}
