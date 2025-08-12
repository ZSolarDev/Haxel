typedef HaxelProject = {
    var sourceFolder:String;
    var exportFolder:String;
}

class HaxelProjectParser {
    public static function parseHaxelProject(projectData:String):HaxelProject
        return cast haxe.Json.parse(projectData);
}
