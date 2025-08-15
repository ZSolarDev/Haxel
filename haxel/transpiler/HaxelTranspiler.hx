package haxel.transpiler;

import haxel.Haxel.HOutput;
import haxel.transpiler.modules.*;
import sys.io.File;

using StringTools;

class HaxelTranspiler {
	static var modules:Map<String, IModule> = ['hxl' => new HXLModule(), 'hxlsl' => new HXLSLModule()];

	public static function getModule(module:String):IModule
		return modules.get(module);

	public static function initModule(module:String, codeBase:Array<String>):IModule
		return modules.get(module).init(codeBase);

	public static function transpile(module:String, file:String):HOutput
		return getModule(module).execute(File.getContent(file));
}
