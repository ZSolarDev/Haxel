package src.haxel;

import src.haxel.parser.ToHaxe;

class Tests {
	static final floatTest:String = 'float uno = 1.0;';
	static final arrayText:String = 'array<string> locales = ["en", "es", "jp"]';

	static function main() {
		final tests = [floatTest, arrayText];

		for (test in tests) {
			Sys.println('haxel: ${test}');
			Sys.println('haxe: ${ToHaxe.convertVariable(test)}');
		}
	}
}
