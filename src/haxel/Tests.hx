package src.haxel;

import src.haxel.parser.ToHaxe;

class Tests {
	static final floatTest:String = 'float uno = 1.0;';
	static final arrayText:String = 'array<string> locales = ["en", "es", "jp"];';
	static final annoyingArrayText:String = 'array<array<array<array<string>>>> annoyance;';

	static function main() {
		final tests = [floatTest, arrayText, annoyingArrayText];

		for (test in tests) {
			Sys.println('haxel: ${test}');
			Sys.println('haxe: ${ToHaxe.convertVariable(test)}');
		}
	}
}
