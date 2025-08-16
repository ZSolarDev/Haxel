package haxel.injector;

import haxel.Haxel.HOutput;
import haxel.injector.injectors.*;

class HXInjector {
	static var injectors:Map<String, IInjector> = ['hxlstd' => new HXLSTDInjector()];

	public static function getInjector(injector:String):IInjector
		return injectors.get(injector);

	public static function injectToSource(injector:String, path:String, project:HaxelProject):HOutput
		return getInjector(injector).injectToSource(path, project);

	public static function injectToFile(injector:String, path:String, project:HaxelProject):HOutput
		return getInjector(injector).injectToFile(path, project);
}
