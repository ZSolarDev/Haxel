package src.haxel.parser;

using StringTools;

class ToHaxe {
	public static function convertVariable(variableDeclaration:String = 'float uno = 1.0;'):String {
		var splitSpaces = variableDeclaration.replace(';', '').split(' ');

		var var_type:String = splitSpaces[0];
		var_type = convertTypes(var_type);

		var var_name:String = splitSpaces[1];
		var var_value:String = (variableDeclaration.replace(';', '').split(' = ')[1]) ?? '';

		return 'var ${var_name}:${var_type}${var_value != '' ? ' = ${var_value}' : ''};';
	}

	static function convertTypes(type:String = 'array<array<string>>') {
		var lowerCaseType = type.toLowerCase();

		lowerCaseType = lowerCaseType.replace('float', 'Float');
		lowerCaseType = lowerCaseType.replace('int', 'Int');
		lowerCaseType = lowerCaseType.replace('string', 'String');
		lowerCaseType = lowerCaseType.replace('array', 'Array');
		lowerCaseType = lowerCaseType.replace('null', 'Null');
		lowerCaseType = lowerCaseType.replace('dynamic', 'Dynamic');

		return lowerCaseType;
	}
}
