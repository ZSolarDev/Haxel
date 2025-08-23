package haxel.injector;

import haxel.Haxel.HOutput;
import haxel.Haxel.Verbose;
import haxel.injector.injectors.*;

class HXInjector {
	static var injectors:Map<String, IInjector> = ['hxlstd' => new HXLSTDInjector(), 'hxldll' => new HXLDLLInjector()];

	public static function getInjector(injector:String):IInjector
		return injectors.get(injector);

	public static function injectToSource(injector:String, path:String, project:HaxelProject, verbose:Verbose):HOutput
		return getInjector(injector).injectToSource(path, project, verbose);

	public static function injectToFile(injector:String, path:String, project:HaxelProject, verbose:Verbose):HOutput
		return getInjector(injector).injectToFile(path, project, verbose);
}
