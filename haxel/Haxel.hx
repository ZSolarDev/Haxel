package haxel;

import haxe.io.Path;
import haxel.HaxelProject;
import haxel.compiler.HaxelCompiler;
import sys.FileSystem;
import sys.io.File;

typedef HOutput = {
	var success:Bool;
	var data:String;
}

typedef Verbose = {
	var enabled:Bool;
	var plus:Bool;
}

class Haxel {
	public static var exit:Bool = false;
	public static var interfaceMessage:String = '
Haxel Command Line Interface Version 0.0.1
----------------------------
Commands:
    build: Builds the project file from the running directory with the specified path. Usage:
        haxel -D build -D [path to project file including file extension] optionals: -D verbose/verbosePlus
    test: Tests the project file from the running directory with the specified path. Usage:
        haxel -D build -D [path to project file including file extension] optionals: -D verbose/verbosePlus
    help: Displays the commands and their usages. Usage:
        haxel -D help
';

	static function verify():HOutput {
		var path:String = '';
		for (arg in Sys.args()) {
			var finalArg = '/$arg';
			if (FileSystem.exists('.${Path.normalize(finalArg)}'))
				path = '.${Path.normalize(finalArg)}';
		}
		if (path == '')
			return {success: false, data: 'INIT_ERROR: Haxel project file does not exist or has not been specified.'};
		return {success: true, data: path};
	}

	static function buildProject(project:HaxelProject, hxlpPath:String, test:Bool = false, verbose:Verbose) {
		var realHxlpPath = './';
		var segments = hxlpPath.split('/');
		for (segmentID in 0...segments.length) {
			if (segmentID != segments.length - 1)
				realHxlpPath += '${segments[segmentID]}/';
		}
		var sourcePath = realHxlpPath + project.sourceFolder;
		var outputPath = realHxlpPath + project.outputFolder;
		if (!FileSystem.exists(sourcePath)) {
			Sys.println("HXLP_ERROR: The source folder wasn't found. Does it exist?");
			exit = true;
			return;
		}
		if (!FileSystem.exists(outputPath))
			FileSystem.createDirectory(outputPath);

		var result = HaxelCompiler.compileProject(project, sourcePath, outputPath, test, verbose);
		if (!result.success || (result.success && !test))
			Sys.println('\n${result.data}\n');
		exit = true;
	}

	static function getVerbose():Verbose {
		var res = {enabled: false, plus: false};
		for (arg in Sys.args()) {
			if (arg == 'verbose')
				res.enabled = true;
			if (arg == 'verbosePlus') {
				res.enabled = true;
				res.plus = true;
			}
		}
		return res;
	}

	public static function main() {
		inline function runBuild(test:Bool = false) {
			var valid = verify();
			var verbose = getVerbose();
			if (valid.success) {
				var project:HaxelProject = HaxelProjectParser.parseHaxelProject(File.getContent(valid.data));
				buildProject(project, valid.data, test, verbose);
			} else {
				Sys.println(valid.data);
				return;
			}
		}
		for (arg in Sys.args()) {
			switch (arg) {
				case 'build':
					runBuild();
				case 'test':
					runBuild(true);
				case 'help':
					Sys.println(interfaceMessage);
					return;
				default:
			}
		}
		if (!exit)
			Sys.println(interfaceMessage);
	}
}
