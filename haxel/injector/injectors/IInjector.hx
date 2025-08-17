package haxel.injector.injectors;

import haxel.Haxel.HOutput;
import haxel.Haxel.Verbose;

interface IInjector {
	public function injectToSource(path:String, project:HaxelProject, verbose:Verbose):HOutput;
	public function injectToFile(path:String, project:HaxelProject, verbose:Verbose):HOutput;
}
