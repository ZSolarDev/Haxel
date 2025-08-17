package haxel.injector.injectors;

import haxel.Haxel.HOutput;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class HXLSTDInjector implements IInjector {
	public var basehxlstd = HaxelStandardLibrary.basehxlstd;
	public var exthxlstd = HaxelStandardLibrary.exthxlstd;

	public function new() {}

	public function injectToSource(path:String, project:haxel.HaxelProject, verbose:Bool):HOutput {
		var res = {success: false, data: ''};
		try {
			if (project.includesHaxelStandardLibrary) {
				for (hxPackage in basehxlstd) {
					var hx = HXLResources.getString(hxPackage);
					var finalHX = hx.replace('haxel.hxlstd', 'hxlstd');
					var almostPath = hxPackage.replace('.', '/').split('/');
					almostPath.pop();
					var finalPath = '$path/${almostPath.join('/')}/';
					if (!FileSystem.exists(finalPath))
						FileSystem.createDirectory(finalPath);

					File.saveContent('$finalPath${hxPackage.replace('.', '/').split('/').pop()}.hx', finalHX);
					if (verbose)
						Sys.println('Injected File: $hxPackage.hx');
				}
			}

			if (project.includesExtendedHaxelStandardLibrary) {
				for (hxPackage in exthxlstd) {
					var hx = HXLResources.getString(hxPackage);
					var finalHX = hx.replace('haxel.hxlstd', 'hxlstd');
					var almostPath = hxPackage.replace('.', '/').split('/');
					almostPath.pop();
					var finalPath = '$path/${almostPath.join('/')}/';
					if (!FileSystem.exists(finalPath))
						FileSystem.createDirectory(finalPath);

					File.saveContent('$finalPath${hxPackage.replace('.', '/').split('/').pop()}.hx', finalHX);
					if (verbose)
						Sys.println('Injected File: $hxPackage.hx');
				}
			}

			res.success = true;
			res.data = 'Successfully injected the Haxel Standard Library!';
			return res;
		} catch (e) {
			res.success = false;
			res.data = '\nHXLINJECTOR_ERROR: ${e.message} || ${e.stack}';
			return res;
		}
	}

	public function injectToFile(path:String, project:haxel.HaxelProject, verbose:Bool):HOutput
		return {success: true, data: ''};
}
