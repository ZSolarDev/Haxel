package haxel.injector.injectors;

import haxel.Haxel.HOutput;

interface IInjector {
	public function injectToSource(path:String, project:HaxelProject, verbose:Bool):HOutput;
	public function injectToFile(path:String, project:HaxelProject, verbose:Bool):HOutput;
}
