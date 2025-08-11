package haxel;

import haxel.parser.ToHaxe;

class Tests {
	public static var floatTest:String = 'float uno = 1.0;';
	public static var arrayTest:String = 'array<string> locales = ["en", "es", "jp"];';
	public static var annoyingArrayTest:String = 'array<array<array<array<string>>>> annoyance;';
	public static var jsonTest:String = '{int one; float two;} coolJson;';

	public static function main() {
	 	var tests = [floatTest, arrayTest, annoyingArrayTest, jsonTest];

		for (test in tests) {
			Sys.println('haxel: ${test}');
			Sys.println('haxe: ${ToHaxe.convertVariable(test)}');
			Sys.println('----------------');
		}
	}
}
