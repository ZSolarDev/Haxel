package src.haxel;

import src.haxel.parser.ToHaxe;

class Tests {
	static final floatTest:String = 'float uno = 1.0;';
	static final arrayTest:String = 'array<string> locales = ["en", "es", "jp"];';
	static final annoyingArrayTest:String = 'array<array<array<array<string>>>> annoyance;';
	static final jsonTest:String = '{int one; float two;} coolJson;';

	static function main() {
		final tests = [floatTest, arrayTest, annoyingArrayTest, jsonTest];

		for (test in tests) {
			Sys.println('haxel: ${test}');
			Sys.println('haxe: ${ToHaxe.convertVariable(test)}');
		}
	}
}
