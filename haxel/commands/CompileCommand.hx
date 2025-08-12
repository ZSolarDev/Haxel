package haxel.commands;

class CompileCommand extends Command {
	override function getName():String {
		return 'compile';
	}

	override function getDescription():String {
		return 'Compiles your Haxel project. Usage:\n\thaxel build [path to project file including file extension]';
	}

	override function onExecuted(app:CliApp, value:Array<String>, options:ParsedOptions) {
		super.onExecuted(app, value, options);

		var valid = validation(value[0]);
		if (valid.valid)
			test();
		else
			app.println(valid.message);
	}

	function validation(path:String):{valid:Bool, message:String} {
		if (path == null)
			return {valid: false, message: 'No Haxel project file specified. Does it exist?'};
		if (!FileSystem.exists(path))
			return {valid: false, message: 'Haxel project file does not exist.'};
		return {valid: true, message: ''};
	}

	var floatTest:String = 'float uno = 1.0';
	var arrayTest:String = 'array<string> locales = ["en", "es", "jp"]';
	var annoyingArrayTest:String = 'array<array<array<array<string>>>> annoyance';
	var jsonTest:String = '{int one; float two;} coolJson';

	function test() {
		var tests = [floatTest, arrayTest, annoyingArrayTest, jsonTest];
		for (test in tests) {
			Sys.println('haxel: ${test}');
			Sys.println('haxe: ${ToHaxe.convertVariable(test)}');
			Sys.println('----------------');
		}
	}
}
