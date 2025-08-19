package haxel.transpiler.modules;

import haxel.Haxel.HOutput;
import haxel.Haxel.Verbose;

class HXLSLModule implements IModule {
	public function new() {}

	// Placeholder
	public function execute(data:String):HOutput {
		var res:HOutput = {success: false, data: ''};
		res.success = true;
		res.data = data;
		return res;
	}

	public function init(codeBase:Array<String>, verbose:Verbose, project:HaxelProject):IModule
		return this;
}
