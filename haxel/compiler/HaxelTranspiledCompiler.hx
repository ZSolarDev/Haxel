package haxel.compiler;

import haxe.io.Path;
import haxel.Haxel.HOutput;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class HaxelTranspiledCompiler {
	public static function compileProject(project:HaxelProject, projectPath:String, transpiledPath:String, outputPath:String, test:Bool = false):HOutput {
		try {
			var output:HOutput = {success: false, data: ''};
			switch (project.graphicsEngine) {
				case FLIXEL:
					var projectXML = '';
					if (FileSystem.exists('$projectPath/Project.xml'))
						projectXML = File.getContent('$projectPath/Project.xml');
					else {
						if (FileSystem.exists('$projectPath/project.xml'))
							projectXML = File.getContent('$projectPath/project.xml');
						else {
							output.data = "HXLCOMPILER_ERROR: a Project.xml file wasn't found. Does it exist?";
							return output;
						}
					}
					File.saveContent('${transpiledPath}Project.xml', projectXML);
					Sys.println('Project.xml created! Building project with flixel to target "${project.flixelTargetOverride == '' ? 'hl' : project.flixelTargetOverride}"');
					Sys.command('lime ${test ? 'test' : 'build'} "${transpiledPath}Project.xml" ${project.flixelTargetOverride == '' ? 'hl' : project.flixelTargetOverride}');
				case HAXEL_GRAPHICS_FRAMEWORK:

				default:
					var hxml = '
--class-path ${transpiledPath}${project.sourceFolder}
--main Main
--cpp ${transpiledPath}bin
                    ';
					FileSystem.createDirectory('${transpiledPath}bin/');
					File.saveContent('${transpiledPath}Project.hxml', hxml);
					Sys.println('Project.hxml created! Building project with haxe cpp...');
					var out = Sys.command('haxe "${transpiledPath}Project.hxml"');
					if (out != 0) {
						throw "\nHaxel Project Failed to compile and I have no idea why, fix your error please!
(This might be an issue with the Haxel Compiler! If you cant figure out the error, please double check the transpiled output just incase it's a syntax error and the transpiler transpiled wrong.";
					}
					if (test) {
						Sys.println('Running compiled project! \n\n');
						Sys.command(('"${transpiledPath.substr(2, transpiledPath.length - 2)}bin/Main.exe"').replace('/', '\\'));
						Sys.println('\n');
					}
			}
			output.success = true;
			output.data = 'Haxel Project Compiled!';
			return output;
		} catch (e) {
			return {success: false, data: '\nHXLCOMPILER_ERROR: (TODO: make it fully error proof) || ${e.message} || ${e.stack}'};
		}
	}
}
