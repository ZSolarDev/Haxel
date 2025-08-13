package haxel.transpiler;

using StringTools;

class HaxelTranspiler {
	static var modules:Map<String, IModule> = [
		'hxl' => new HXLModule(),
		'hxlsl' => new HXLSLModule();
	];

	public function getModule(module:String):IModule
		return modules.get(module);

	public function transpile(module:String, file:String):HOutput
		return getModule(module).execute(File.getContent(file))
}
