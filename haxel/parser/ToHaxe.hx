package haxel.parser;

class ToHaxe {
	static function convertInlineStructType(typeStr:String):String {
		var inner = typeStr.trim();
		if (inner.startsWith('{') && inner.endsWith('}')) {
			inner = inner.substring(1, inner.length - 1);
		} else
			return typeStr;

		var fields = inner.split(';').map((field) -> {
			return field.trim();
		}).filter((f) -> {
			return f != '';
		});

		var convertedFields = fields.map((field) -> {
			var parts = field.split(' ');
			if (parts.length != 2)
				return field; // fallback

			var t = convertTypes(parts[0]);
			var n = parts[1];
			return '${n}:${t}';
		});

		return '{' + convertedFields.join(', ') + '}';
	}

	public static function convertVariable(variableDeclaration:String = 'float uno = 1.0;'):String {
		var trimmedDecl = variableDeclaration.trim();

		var varValue:String = '';
		if (trimmedDecl.contains(' = ')) {
			var parts = trimmedDecl.split(' = ');
			trimmedDecl = parts[0];
			varValue = parts[1];
		}

		var words = trimmedDecl.split(' ');
		var varName = words[words.length - 1];
		var typeStr = words.slice(0, words.length - 1).join(' ');

		if (typeStr.startsWith('{'))
			typeStr = convertInlineStructType(typeStr);
		else
			typeStr = convertTypes(typeStr);

		return 'var ${varName}:${typeStr}${varValue != '' ? ' = ${varValue}' : ''};';
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
