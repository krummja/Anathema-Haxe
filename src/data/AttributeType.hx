package data;

enum AttributeType {
	Physical(c: AttributeClass);
	Mental(c: AttributeClass);
	Social(c: AttributeClass);
}

enum AttributeClass {
	Power;
	Finesse;
	Resistance;
}
