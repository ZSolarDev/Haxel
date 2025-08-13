package haxel.transpiler.modules;

import haxel.Haxel.HOutput;

class HXLSLModule implements IModule
{
    public function new() {}

    // Placeholder
    public function execute(data:String):HOutput {
        var res:HOutput = {success: false, data: ''};
        res.success = true;
        res.data = data;
		return res;
	}
}