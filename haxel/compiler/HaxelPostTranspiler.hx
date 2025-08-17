package haxel.compiler;

import haxel.Haxel.HOutput;
import haxel.Haxel.Verbose;
import haxel.injector.HXInjector;

class HaxelPostTranspiler {
	public static function compileProject(project:HaxelProject, projectPath:String, transpiledPath:String, outputPath:String, test:Bool = false,
			verbose:Verbose):HOutput {
		var output:HOutput = {success: false, data: ''};
		var output = HXInjector.injectToSource('hxlstd', '$outputPath/transpiled/source', project, verbose);
		if (output.success) {
			Sys.println('${verbose.plus ? '\n' : ''}Successfully injected the Haxel Standard Library! Compiling transpiled files...');
			output = HaxelTranspiledCompiler.compileProject(project, projectPath, transpiledPath, outputPath, test, verbose);
			return output;
		} else
			return output;
	}
}
