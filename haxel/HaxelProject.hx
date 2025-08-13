package haxel;

enum abstract HaxelGraphicsEngine(String) {
	var FLIXEL = 'flixel';
	var HAXEL_GRAPHICS_FRAMEWORK = 'haxel-graphics-framework';
	var CUSTOM = 'custom';
}

typedef HaxelProject = {
	var sourceFolder:String;
	var outputFolder:String;
	var graphicsEngine:HaxelGraphicsEngine;
	var copiedFolders:Array<String>;
	var flixelTargetOverride:String;
}

class HaxelProjectParser {
	public static function parseHaxelProject(projectData:String):HaxelProject
		return cast haxe.Json.parse(projectData);
}
