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
					Sys.println('Project.hxml created! Building project with hxcpp...');
					var out = Sys.command('haxe "${transpiledPath}Project.hxml"');
					if (out != 0)
						throw "\nHaxel Compiler detected a failed compile!\n";
					if (test) {
						Sys.println('Running compiled project! \n\n');
						FileSystem.rename('${transpiledPath}bin/Main.exe', '${transpiledPath}bin/${project.haxeExeName}.exe');
						Sys.command(('"${transpiledPath.substr(2, transpiledPath.length - 2)}bin/${project.haxeExeName}.exe"').replace('/', '\\'));
					}
			}
			output.success = true;
			output.data = 'Haxel Project Compiled!';
			return output;
		} catch (e) {
			return {success: false, data: '\nHXLCOMPILER_ERROR:  ${e.message} || ${e.stack}'};
		}
	}
}
