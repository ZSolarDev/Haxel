package haxel;

import haxel.parser.ToHaxe;
import sys.FileSystem;

class Haxel {
	public static var floatTest:String = 'float uno = 1.0';
	public static var arrayTest:String = 'array<string> locales = ["en", "es", "jp"]';
	public static var annoyingArrayTest:String = 'array<array<array<array<string>>>> annoyance';
	public static var jsonTest:String = '{int one; float two;} coolJson';
	public static var interfaceMessage:String = '
Haxel Command Line Interface Version 0.0.1
----------------------------
Commands:
    build: Builds the project file from the running directory with the specified path. Usage:
        haxel build [path to project file including file extension]
    help: Displays the commands and their usages. Usage:
        haxel help
';

	static function verify(path:String):{valid:Bool, message:String} {
		if (path == null)
			return {valid: false, message: 'No Haxel project file specified. Does it exist?'};
		if (!FileSystem.exists(path))
			return {valid: false, message: 'Haxel project file does not exist.'};
		return {valid: true, message: ''};
	}

	public static function main() {
		for (arg in Sys.args()) {
			switch (arg) {
				case 'build':
					var valid = verify(Sys.args()[Sys.args().indexOf(arg) + 1]);
					if (valid.valid) {
						var tests = [floatTest, arrayTest, annoyingArrayTest, jsonTest];
						for (test in tests) {
							Sys.println('haxel: ${test}');
							Sys.println('haxe: ${ToHaxe.convertVariable(test)}');
							Sys.println('----------------');
						}
					} else {
						Sys.println(valid.message);
						return;
					}
				case 'help':
					Sys.println(interfaceMessage);
					return;
				default:
			}
		}
		Sys.println(interfaceMessage);
	}
}
