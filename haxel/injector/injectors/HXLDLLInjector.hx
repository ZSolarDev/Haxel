package haxel.injector.injectors;

import haxel.Haxel.HOutput;
import haxel.Haxel.Verbose;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class HXLDLLInjector implements IInjector {
	public function new() {}

	public function injectToSource(path:String, project:haxel.HaxelProject, verbose:Verbose):HOutput {
		var res = {success: false, data: ''};
		try {
			if (project.graphicsEngine != NONE_OR_CUSTOM || project.includesHaxelStandardLibrary) {
				var inject = project.graphicsEngine == HAXEL_GRAPHICS_FRAMEWORK;
				if (project.graphicsEngine == FLIXEL) {
					if (project.flixelOptions.targetOverride == ''
						|| project.flixelOptions.targetOverride == 'hl'
						|| project.flixelOptions.targetOverride == 'cpp'
						|| project.flixelOptions.targetOverride == 'windows')
						inject = true;
				}
				if (inject) {
					var path = '$path/_HAXEL_RAYTRACING_/';
					if (!FileSystem.exists(path))
						FileSystem.createDirectory(path);
					var ext = project.flixelOptions.targetOverride == ''
						|| project.flixelOptions.targetOverride == 'hl' ? 'h' : project.flixelOptions.targetOverride == 'cpp'
							|| project.flixelOptions.targetOverride == 'windows' ? 'n' : '';
					File.saveContent('${path}haxelraytracing.${ext}dll', HXLResources.getString('HaxelRaytracing.${ext}dll'));
					if (verbose.plus)
						Sys.println('Injected File: haxelraytracing.${ext}dll');
				}
			}

			res.success = true;
			res.data = 'Successfully injected all Haxel DLLs!';
			return res;
		} catch (e) {
			res.success = false;
			res.data = '\nHXLINJECTOR_ERROR: ${e.message} || ${e.stack}';
			return res;
		}
	}

	public function injectToFile(path:String, project:haxel.HaxelProject, verbose:Verbose):HOutput
		return {success: true, data: ''};
}
