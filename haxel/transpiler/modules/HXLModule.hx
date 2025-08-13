package haxel.transpiler.modules;

import haxel.Haxel.HOutput;

using StringTools;

class HXLModule implements IModule {
	public var types:Array<String> = [
		'float',
		'int',
		'string',
		'bool',
		'array',
		'null', // like null<type>
		'dynamic'
	];
	public function new() {}

	// Placeholder
	public function execute(data:String):HOutput {
		var res:HOutput = {success: false, data: ''};
		for (pattern in patterns) {
        var pos = 0;
        while (pos < result.length) {
            pos = result.indexOf(pattern, pos);
            if (pos == -1) break; // No more occurrences of pattern

            // Check if the pattern is followed by a space and an alphanumeric string
            var start = pos + pattern.length;
            if (start < result.length && result.charAt(start) == ' ') {
                // Now check if the next part is alphanumeric
                var end = start + 1;
                while (end < result.length && (Std.isDigit(result.charAt(end)) || (result.charAt(end) >= 'A' && result.charAt(end) <= 'Z') || (result.charAt(end) >= 'a' && result.charAt(end) <= 'z'))) {
                    end++;
                }

                // If we found an alphanumeric string after the space, apply the transformation
                if (end > start + 1) {
                    var alphanumericPart = result.substring(start + 1, end);
                    var transformed = transformAlphanumeric(alphanumericPart);
                    result = result.substring(0, start + 1) + transformed + result.substring(end);
                }
            }
            pos = start + 1; // Move past the last pattern match to continue searching
        }
    }
		res.success = true;
		res.data = data;
		return res;
	}

	public function init(codeBase:Array<String>)
	{
		for (sourceFile in codeBase)
		{
			var content:String = File.getContent(sourcrFile);
			
			// match keyword, space, then capture the following alphanumeric word
			// I actually have no idea if this works
            var regex = ~/\b(?:typedef|enum|class|interface)\s+([A-Za-z0-9<>()]+)/g;
            while (regex.match(content)) {
                types.push(regex.matched(1)); // captured name
    		}
		}
	}

	public function convertVariableDecl(variableDeclaration:String = 'float uno = 1.0;'):String {
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

	public function convertInlineStructType(typeStr:String):String {
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

	public function convertTypes(type:String = 'array<array<string>>') {
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
