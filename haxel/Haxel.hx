package haxel;

import haxe.io.Path;
import haxel.HaxelProject;
import haxel.compiler.HaxelCompiler;
import sys.FileSystem;
import sys.io.File; // I think this is right

typedef HOutput = {
	var success:Bool;
	var data:String;
}

class Haxel {
	public static var exit:Bool = false;
	public static var interfaceMessage:String = '
Haxel Command Line Interface Version 0.0.1
----------------------------
Commands:
    build: Builds the project file from the running directory with the specified path. Usage:
        haxel build [path to project file including file extension]
    help: Displays the commands and their usages. Usage:
        haxel help
';

	static function verify():HOutput {
		var path:String = '';
		for (arg in Sys.args())
			if (FileSystem.exists('.${Path.normalize(arg)}'))
				path = '.${Path.normalize(arg)}';
		if (path == '')
			return {success: false, data: 'INIT_ERROR: Haxel project file does not exist or has not been specified.'};
		return {success: true, data: path};
	}

	static function buildProject(project:HaxelProject, hxlpPath:String) {
		// Placeholder for now
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

		var result = HaxelCompiler.compileProject(project, sourcePath, outputPath);
		var resultMessage:String = result.success ? 'HXLCOMPILE_SUCCESS: ${result.data}' : 'HXLCOMPILE_ERROR: ${result.data}';
		Sys.println(resultMessage);
		exit = true;
	}

	public static function main() {
		for (arg in Sys.args()) {
			switch (arg) {
				case 'build':
					var valid = verify();
					if (valid.success) {
						var project:HaxelProject = HaxelProjectParser.parseHaxelProject(File.getContent(valid.data));
						buildProject(project, valid.data);
					} else {
						Sys.println(valid.data);
						return;
					}
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
