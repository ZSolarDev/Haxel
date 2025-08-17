package haxel;

enum abstract HaxelGraphicsEngine(String) {
	var FLIXEL = 'flixel';
	var HAXEL_GRAPHICS_FRAMEWORK = 'haxel-graphics-framework';
	var NONE_OR_CUSTOM = 'none-or-custom';
}

typedef FlixelDefine = {
	var name:String;
	var data:String;
}

typedef FlixelOptions = {
	var appName:String;
	var fileName:String;
	var mainClass:String;
	var version:String;
	var company:String;

	var windowTags:Array<String>;
	var defines:Array<FlixelDefine>;
	var miscTags:Array<String>;
	var pureInjections:Array<String>;

	var targetOverride:String;
}

typedef HGFOptions = {}

typedef HaxeOptions = {
	var exeName:String;
}

typedef HaxelProject = {
	var includesExtendedHaxelStandardLibrary:Bool;
	var includesHaxelStandardLibrary:Bool;
	var flixelOptions:FlixelOptions;
	var haxelGraphicsFrameworkOptions:HGFOptions;
	var haxeOptions:HaxeOptions;
	var sourceFolder:String;
	var outputFolder:String;
	var graphicsEngine:HaxelGraphicsEngine;
	var copiedFolders:Array<String>;
	var libraries:Array<String>;
}

class HaxelProjectParser {
	public static function parseHaxelProject(projectData:String):HaxelProject
		return cast haxe.Json.parse(projectData);
}
