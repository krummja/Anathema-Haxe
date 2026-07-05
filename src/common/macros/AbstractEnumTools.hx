package common.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.Tools;
#end

class AbstractEnumTools {
	public static macro function getValues(typePath: Expr): Expr {
		var typeStr = typePath.toString();
		var type = Context.getType(typeStr);

		switch (type.follow()) {
			case TAbstract(_.get() => ab, _) if (ab.meta.has(":enum")):
				var exprs: Array<Expr> = [];

				for (field in ab.impl.get().statics.get()) {
					if (field.meta.has(":enum") && field.meta.has(":impl")) {
						var fieldName = field.name;
						exprs.push(macro $p{[typeStr, fieldName]});
					}
				}

				return macro $a{exprs};

			default:
				Context.error(typeStr + "is not an enum abstract", typePath.pos);
				return macro null;
		}
	}
}
