package src.haxel.parser;

class ToHaxe {
	public static function convertVariable(variableDeclaration:String = 'float uno = 1.0;'):String {
		var splitSpaces = variableDeclaration.split(' ');

		var var_type:String = splitSpaces[0].split('<')[0];
		var var_array_otherside:String = splitSpaces[0].split('<')[1] ?? '';

		switch (var_array_otherside.toLowerCase()) {
			// https://tenor.com/view/springtrap-fire-fnaf-gif-2873982408042466685
			// case 'array':
			// 	var_array_otherside = 'Array<${var_array_otherside}>';
			case 'dynamic':
				var_array_otherside = 'Dynamic';
			case 'string':
				var_array_otherside = 'String';
			case 'int':
				var_array_otherside = 'Int';
			case 'float':
				var_array_otherside = 'Float';
		}

		switch (var_type.toLowerCase()) {
			case 'array':
				var_type = 'Array<${var_array_otherside}>';
			case 'dynamic':
				var_type = 'Dynamic';
			case 'string':
				var_type = 'String';
			case 'int':
				var_type = 'Int';
			case 'float':
				var_type = 'Float';
		}

		var var_name:String = splitSpaces[1];
		var var_value:String = splitSpaces[3] ?? '';

		return 'var ${var_name}:${var_type}${var_value != '' ? ' = ${var_value}' : ''}';
	}
}
