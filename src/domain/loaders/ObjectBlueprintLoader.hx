package domain.loaders;

import engine.XMLLoader;
import haxe.xml.Access;

typedef Part = {
	var name: String;
	var parameters: Map<String, String>;
}

typedef Builder = {
	var name: String;
	var ?tiles: String;
	var ?forceName: String;
	var ?chanceOneIn: String;
}

typedef RemoveBuilder = {
	var name: String;
}

typedef Skill = {
	var name: String;
}

typedef InventoryObject = {
	var blueprint: String;
	var number: String;
}

typedef Stat = {
	var name: String;
	var value: String;
}

typedef Property = {
	var name: String;
	var value: String;
}

typedef IntProperty = {
	var name: String;
	var value: Int;
}

typedef Tag = {
	var name: String;
	var ?value: String;
}

typedef XTag = {
	var part: String;
	var parameters: Dynamic;
}

typedef STag = {
	var name: String;
	var value: String;
}

typedef Mixin = {
	var name: String;
	var ?exclude: String;
	var ?load: String;
}

typedef ObjectBlueprint = {
	> XMLData,
	var name: String;
	var inherits: String;
	var parts: Array<Part>;
	var skills: Array<Skill>;
	var inventoryObjects: Array<InventoryObject>;
	var stats: Array<Stat>;
	var properties: Array<Property>;
	var intProperties: Array<IntProperty>;
	var tags: Array<Tag>;
	var xTags: Array<XTag>;
	var sTags: Array<STag>;
	var mixins: Array<Mixin>;
}

class ObjectBlueprintLoader extends XMLLoader<ObjectBlueprint> {
	public var objectBlueprints(default, null): Map<String, ObjectBlueprint>;

	public function new() {
		super("xml/ObjectBlueprints");

		objectBlueprints = new Map();

		load("RootObjects");

		for (name in xmlData.keys()) {
			var bp = parse(name);

			// objectBlueprints.set(name, parse(name));
		}
	}

	public override function parse(name: String): Null<ObjectBlueprint> {
		var blueprint = xmlData.get(name);

		var parts: Array<Part> = new Array();
		var skills: Array<Skill> = new Array();
		var inventoryObjects: Array<InventoryObject> = new Array();
		var stats: Array<Stat> = new Array();
		var properties: Array<Property> = new Array();
		var intProperties: Array<IntProperty> = new Array();
		var tags: Array<Tag> = new Array();
		var xTags: Array<XTag> = new Array();
		var sTags: Array<STag> = new Array();
		var mixins: Array<Mixin> = new Array();

		for (partXml in blueprint.elementsNamed("part")) {
			var partAccess = new Access(partXml);

			var part = {
				name: partAccess.att.name,
				parameters: new Map(),
			};

			for (att in partXml.attributes()) {
				var value = Reflect.getProperty(partAccess.att, att);
				if (
					att != "name" ||
					att != "inherits"
				) {
					part.parameters.set(att, value);
				}
			}

			parts.push(part);
		}

		if (blueprint != null) {
			return {
				name: "Test",
				inherits: "",
				parts: parts,
				skills: skills,
				inventoryObjects: inventoryObjects,
				stats: stats,
				properties: properties,
				intProperties: intProperties,
				tags: tags,
				xTags: xTags,
				sTags: sTags,
				mixins: mixins,
			};
		}

		return null;
	}
}
