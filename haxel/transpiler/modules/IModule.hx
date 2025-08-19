package haxel.transpiler.modules;

import haxel.Haxel.HOutput;
import haxel.Haxel.Verbose;

interface IModule {
	public function execute(data:String):HOutput;
	public function init(codeBase:Array<String>, verbose:Verbose, project:HaxelProject):IModule;
}
