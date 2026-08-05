package common.util;

function getMatches(ereg: EReg, input: String, index: Int = 0): Array<String> {
	var matches = [];
	while (ereg.match(input)) {
		matches.push(ereg.matched(index));
		input = ereg.matchedRight();
	}
	return matches;
}
