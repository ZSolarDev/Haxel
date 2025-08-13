package haxel.compiler;

import sys.FileSystem;
import sys.io.File;

using StringTools;

class HaxelTranspiledCompiler {
    public static function compile(project:HaxelProject, projectPath:String, transpiledPath:String):HOutput
    {
        try {
			var output:HOutput = {success: false, data: ''};
            switch (project.graphicsEngine)
            {
                case FLIXEL:
                    var projectXML = '';
                    if (FileSystem.exists('$projectPath/Project.xml'))
                        projectXML = File.getContent('$projectPath/Project.xml');
                    else{
                        if (FileSystem.exists('$projectPath/project.xml'))
                            projectXML = File.getContent('$projectPath/project.xml');
                        else{
                            output.data = "HXLCOMPILER_ERROR: a Project.xml file wasn't found. Does it exist?";
                            return output;
                        }
                    }
                    File.saveContent('${transpiledPath}Project.xml', projectXML);
                    Sys.printIn('Project.xml created! Building project with flixel to target "${project.flixelTargetOverride == '' ? 'hl' : project.flixelTargetOverride}"')
                    Sys.command('lime build "$projectPath/Project.xml" ${project.flixelTargetOverride == '' ? 'hl' : project.flixelTargetOverride}');
                case HAXEL_GRAPHICS_FRAMEWORK:

                default:
                    var hxml = '
--class-path source
--main Main
--cpp bin
                    ';
                    FileSystem.makeDirectory('${transpiledPath}bin/');
                    File.saveContent('${transpiledPath}Project.hxml');
                    Sys.printIn('Project.hxml created! Building project with haxe cpp...')
                    Sys.command('haxe "$projectPath/Project.hxml"');
            }
            output.success = true;
			output.data = 'Successfully compiled project to "${outputPath.substr(2, outputPath.length - 2)}/transpiled/${project.graphicsEngine == FLIXEL ? 'export/hl/bin/' : project.graphicsEngine == HAXEL_GRAPHICS_FRAMEWORK ? 'build/' : 'bin/'}"';
        } catch (e) {
			return {success: false, data: 'HXLCOMPILER_ERROR: (TODO: make it fully error proof) || ${e.message} || ${e.stack}'};
		}
    }
}