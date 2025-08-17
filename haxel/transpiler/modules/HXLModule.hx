package haxel.transpiler.modules;

import haxel.Haxel.HOutput;
import haxel.Haxel.Verbose;
import sys.io.File;

using StringTools;

// this was worse than the compiler...
class HXLModule implements IModule {
	public var types:Array<String> = [
		'float',
		'int',
		'string',
		'bool',
		'array',
		'void',
		'null', // like null<type>
		'dynamic'
	];

	var modifiers = [
		'public',
		'private',
		'protected',
		'inline',
		'override',
		'static',
		'final',
		'abstract'
	];

	public var keyWords = ['extends', 'implements', 'is'];

	public function new() {}

	function inString(pos:Int, code:String):Bool {
		var inSingle = false;
		var inDouble = false;
		for (i in 0...code.length) {
			var c = code.charAt(i);

			if (c == '"' && !inSingle) {
				inDouble = !inDouble;
			} else if (c == '\'' && !inDouble) {
				inSingle = !inSingle;
			}

			if (i == pos)
				return inSingle || inDouble;
		}
		return false;
	}

	// TODO: support TypeHere<T, T, ....>
	public function execute(data:String):HOutput {
		var res:HOutput = {success: false, data: ''};
		var result = data;

		for (type in types) {
			var pos = 0;
			while (pos < result.length) {
				pos = result.indexOf(type, pos);
				if (pos == -1)
					break;

				if (inString(pos, result)) {
					pos += type.length;
					continue;
				}

				var modifier = "";
				var beforeChunk = result.substring(cast Math.max(0, pos - 20), pos).rtrim();
				for (m in modifiers) {
					if (beforeChunk.endsWith(m)) {
						modifier = m + " ";
						break;
					}
				}

				var start = pos + type.length;
				if (start < result.length && result.charAt(start) == ' ') {
					var end = start + 1;

					while (end < result.length
						&& ((result.charAt(end) >= '0' && result.charAt(end) <= '9')
							|| (result.charAt(end) >= 'A' && result.charAt(end) <= 'Z')
							|| (result.charAt(end) >= 'a' && result.charAt(end) <= 'z')
							|| result.charAt(end) == '_')) {
						end++;
					}

					if (end < result.length && result.charAt(end) == '(') {
						var parenCount = 1;
						end++;
						while (end < result.length && parenCount > 0) {
							if (result.charAt(end) == '(')
								parenCount++;
							else if (result.charAt(end) == ')')
								parenCount--;
							end++;
						}
					}

					var alphanumericPart = result.substring(start + 1, end);
					var valid = true;

					for (keyWord in keyWords) {
						if (alphanumericPart == keyWord) {
							valid = false;
							break;
						}
					}

					var insideParams = false;
					var searchPos = pos;
					while (searchPos >= 0) {
						var ch = result.charAt(searchPos);
						if (ch == ')')
							break; // we passed the param list
						if (ch == '(') {
							insideParams = true;
							break;
						}
						searchPos--;
					}

					if (insideParams) {
						result = result.substring(0, pos) + alphanumericPart + ":" + convertTypes(type) + result.substring(pos + (end - pos));
						pos = start + 1;
						continue;
					}
					if (valid) {
						var isFunction = alphanumericPart.indexOf('(') != -1;
						var declaration:String = isFunction ? '${modifier}function $alphanumericPart:${convertTypes(type)}' : '${modifier}var ${convertVariableDecl(type + ' ' + alphanumericPart)}';
						var cutStart = modifier != "" ? (pos - modifier.length) : pos;
						result = result.substring(0, cutStart) + declaration + result.substring(pos + (end - pos));
					}
				}

				pos = start + 1;
			}
		}

		res.success = true;
		res.data = result;
		return res;
	}

	static function getBeforeBracket(s:String):String {
		var i = s.indexOf("<");
		if (i == -1)
			return s;
		return s.substr(0, i);
	}

	public static function stripComments(src:String):String {
		var out = new StringBuf();
		var i = 0;
		var len = src.length;
		while (i < len) {
			var c = src.charAt(i);
			if (c == "/" && i + 1 < len) {
				var c2 = src.charAt(i + 1);
				if (c2 == "/") {
					// line comment: skip until newline (but keep newline)
					i += 2;
					while (i < len && src.charAt(i) != '\n')
						i++;
					if (i < len) {
						out.add("\n");
						i++;
					}
				} else if (c2 == "*") {
					// block comment: advance until */; preserve newlines inside
					i += 2;
					while (i + 1 < len && !(src.charAt(i) == '*' && src.charAt(i + 1) == '/')) {
						if (src.charAt(i) == '\n')
							out.add("\n");
						i++;
					}
					i += 2; // skip */
				} else {
					out.add(c);
					i++;
				}
			} else {
				out.add(c);
				i++;
			}
		}
		return out.toString();
	}

	public function init(codeBase:Array<String>, verbose:Verbose):IModule {
		for (sourceFile in codeBase) {
			if (sourceFile.endsWith('.hxl') || sourceFile.endsWith('.hx')) {
				if (verbose.plus)
					Sys.println('Searching for types in $sourceFile');
				var content:String = stripComments(File.getContent(sourceFile));

				// match keyword, space, then capture the following alphanumeric word
				var regex = ~/\b(?:typedef|enum|class|interface)\s+([A-Za-z0-9<>()]+)/g;
				if (regex.match(content)) {
					var type = regex.matched(1); // captured name
					if (type.charAt(0).toUpperCase() == type.charAt(0))
						if (!types.contains(type))
							types.push(getBeforeBracket(type));
				}
			}
		}
		return this;
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

		return '${varName}:${typeStr}';
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
		var finalType = type;

		finalType = finalType.replace('float', 'Float');
		finalType = finalType.replace('int', 'Int');
		finalType = finalType.replace('string', 'String');
		finalType = finalType.replace('array', 'Array');
		finalType = finalType.replace('null', 'Null');
		finalType = finalType.replace('bool', 'Bool');
		finalType = finalType.replace('void', 'Void');
		finalType = finalType.replace('dynamic', 'Dynamic');

		return finalType;
	}
}
