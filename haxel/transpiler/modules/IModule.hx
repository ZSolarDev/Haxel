package haxel.transpiler.modules;

import haxel.Haxel.HOutput;

interface IModule {
    public function execute(data:String):HOutput;
}