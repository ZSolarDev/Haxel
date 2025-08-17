package haxel.compiler;

import haxe.io.Path;
import haxel.Haxel.HOutput;
import haxel.Haxel.Verbose;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class HaxelTranspiledCompiler {
	public static function compileProject(project:HaxelProject, projectPath:String, transpiledPath:String, outputPath:String, test:Bool = false,
			verbose:Verbose):HOutput {
		try {
			var output:HOutput = {success: false, data: ''};
			if (!project.libraries.contains('format'))
				project.libraries.push('format');
			switch (project.graphicsEngine) {
				case FLIXEL:
					var projectXML = '';
					if (FileSystem.exists('$projectPath/Project.xml'))
						projectXML = File.getContent('$projectPath/Project.xml');
					else {
						if (FileSystem.exists('$projectPath/project.xml'))
							projectXML = File.getContent('$projectPath/project.xml');
						else {
							if (verbose.enabled)
								Sys.println("A Project.xml file wasn't found. Automatically creating one...");
							if (!project.libraries.contains('flixel'))
								project.libraries.push('flixel');
							projectXML = '
<?xml version="1.0" encoding="utf-8"?>
<project xmlns="http://lime.openfl.org/project/1.0.4" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://lime.openfl.org/project/1.0.4 http://lime.openfl.org/xsd/project-1.0.4.xsd">

    <app title="${project.flixelOptions.appName}" file="${project.flixelOptions.fileName}" main="${project.flixelOptions.mainClass}" version="${project.flixelOptions.version}" company="${project.flixelOptions.company}" />
    <set name="BUILD_DIR" value="export" />
    <source path="source" />
                            ';
							if (project.flixelOptions.windowTags.length > 0)
								projectXML += '\n    <!-- ___________ Window Options __________ -->';
							for (windowTag in project.flixelOptions.windowTags)
								projectXML += '
    <window ${windowTag.replace("'", '"')} />';
							if (project.copiedFolders.length > 0)
								projectXML += '\n\n    <!-- _______________ Assets ______________ -->';
							for (folder in project.copiedFolders)
								projectXML += '
    <assets path="$folder" />';
							projectXML += '\n\n    <!-- _____________ Libraries _____________ -->';
							for (library in project.libraries)
								projectXML += '
    <haxelib name="$library" />';
							if (project.flixelOptions.defines.length > 0)
								projectXML += '\n\n    <!-- ______________ Defines ______________ -->';
							for (define in project.flixelOptions.defines)
								projectXML += '
    <haxedef name="${define.name}" ${define.data.replace("'", '"')} />';

							if (project.flixelOptions.miscTags.length > 0)
								projectXML += '\n\n    <!-- ________________ Misc _______________ -->';
							for (miscTag in project.flixelOptions.miscTags)
								projectXML += '
    <${miscTag.replace("'", '"')} />';
							for (pureInjection in project.flixelOptions.pureInjections)
								projectXML += '
    ${pureInjection.replace("'", '"')}';
						}
						projectXML += '\n</project>';
						if (verbose.plus)
							Sys.println('Project.xml created!\n$projectXML\n\n');
						else if (verbose.enabled)
							Sys.println('Project.xml created!');
					}
					File.saveContent('${transpiledPath}Project.xml', projectXML);
					Sys.println('Building project with flixel to target "${project.flixelOptions.targetOverride == '' ? 'hl' : project.flixelOptions.targetOverride}"\n');
					Sys.command('lime ${test ? 'test' : 'build'} "${transpiledPath}Project.xml" ${project.flixelOptions.targetOverride == '' ? 'hl' : project.flixelOptions.targetOverride}');
				case HAXEL_GRAPHICS_FRAMEWORK:

				default:
					var hxml = '
--class-path ${transpiledPath}${project.sourceFolder}
--main Main
--cpp ${transpiledPath}bin
                    ';
					for (library in project.libraries)
						hxml += '\n--library ${library}';
					FileSystem.createDirectory('${transpiledPath}bin/');
					File.saveContent('${transpiledPath}Project.hxml', hxml);
					Sys.println('Project.hxml created! Building project with hxcpp...');
					var out = Sys.command('haxe "${transpiledPath}Project.hxml"');
					if (out != 0)
						throw "\nHaxel Compiler detected a failed compile!\n";
					if (test) {
						Sys.println('Running compiled project! \n\n');
						FileSystem.rename('${transpiledPath}bin/Main.exe', '${transpiledPath}bin/${project.haxeOptions.exeName}.exe');
						Sys.command(('"${transpiledPath.substr(2, transpiledPath.length - 2)}bin/${project.haxeOptions.exeName}.exe"').replace('/', '\\'));
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
