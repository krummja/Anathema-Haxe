package common.graphgen;

import haxe.Exception;
import utest.Test;

enum abstract TokenType(String) from String to String {
	var Eof;
	var Semicolon;
	var Equals;
	var Lbrace;
	var Rbrace;
	var Arrow;
	var Lparen;
	var Rparen;
	var Quote;
	var Comma;
	var Property;
	var Number;
	var Id;
}

class Token {
	public var tokenType: TokenType;
	public var text: String;

	public function new(tokenType: TokenType, text: String) {
		this.tokenType = tokenType;
		this.text = text;
	}

	public function equals(other: Token) {
		return tokenType == other.tokenType && text == other.text;
	}
}

class Lexer {
	private var inputStream: String;
	private var pos: Int;
	private var lineNum: Int;
	private var charNum: Int;

	private var char: String;

	public function new(inputString: String) {
		this.inputStream = inputString;
		pos = 0;
		lineNum = 1;
		charNum = 1;

		if (inputStream.length != 0) {
			char = inputStream.charAt(pos);
		} else {
			char = TokenType.Eof;
		}
	}

	public function nextToken(): Token {
		var isDigit = (c: String) -> ~/^\d+$/.match(c);
		var isAlpha = (c: String) -> ~/^[a-zA-Z]$/.match(c);

		while (char != TokenType.Eof) {
			if ([" ", "\t", "\n", "\r"].contains(char)) {
				consume();
			} else if (["'", '"'].contains(char)) {
				consume();
				return new Token(Quote, '"');
			} else if (char == ";") {
				consume();
				return new Token(Semicolon, ";");
			} else if (char == ",") {
				consume();
				return new Token(Comma, ",");
			} else if (char == "{") {
				consume();
				return new Token(Lbrace, "{");
			} else if (char == "}") {
				consume();
				return new Token(Rbrace, "}");
			} else if (char == "(") {
				consume();
				return new Token(Lparen, "(");
			} else if (char == ")") {
				consume();
				return new Token(Rparen, ")");
			} else if (char == "-") {
				consume();
				if (char == ">") {
					consume();
					return new Token(Arrow, "->");
				} else {
					error();
				}
			} else if (char == "=") {
				consume();
				return new Token(Quote, "=");
			} else if (char == "#") {
				while (char != Eof && char != "\n") {
					consume();
				}
			} else if (isDigit(char)) {
				var lexeme = "";
				while (char != Eof && isDigit(char)) {
					lexeme += char;
					consume();
				}
				return new Token(Number, lexeme);
			} else if (isAlpha(char)) {
				var lexeme = "";
				while (char != Eof && (isAlpha(char) || isDigit(char) || char == "_")) {
					lexeme += char;
					consume();
				}
				return new Token(Id, lexeme);
			} else {
				error();
			}
		}

		return new Token(Eof, "<EOF>");
	}

	private function consume() {
		if (["\n", "\r"].contains(char)) {
			lineNum++;
			charNum++;
		} else {
			charNum++;
		}

		pos++;

		if (pos >= inputStream.length) {
			char = TokenType.Eof;
		} else {
			char = inputStream.charAt(pos);
		}
	}

	private function error() {
		throw new Exception('Invalid character ${char} at [${lineNum}:${charNum}]');
	}
}

class TestLexer extends Test {
	private var testTarget: String;
	private var lexer: Lexer;
	private var lookahead: Token;
	private var tokens: Array<Token>;

	public function setup() {
		testTarget = "
            foo {
                bar {
                    a = 10;
                    b = 'B';

                }
            }
        ";
		lexer = new Lexer(testTarget);
		lookahead = lexer.nextToken();
		tokens = [lookahead];
	}

	public function testLexer() {
		var tokens = [];
		while (lookahead.tokenType != Eof) {
			var next = lexer.nextToken();
			tokens.push(next);
		}
	}
}
