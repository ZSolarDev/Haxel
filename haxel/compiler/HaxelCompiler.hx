package haxel.compiler;

import haxe.io.Path;
import haxel.Haxel.HOutput;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class HaxelCompiler {
	/*
		public static var floatTest:String = 'float uno = 1.0';
		public static var arrayTest:String = 'array<string> locales = ["en", "es", "jp"]';
		public static var annoyingArrayTest:String = 'array<array<array<array<string>>>> annoyance';
		public static var jsonTest:String = '{int one; float two;} coolJson';

		var tests = [floatTest, arrayTest, annoyingArrayTest, jsonTest];
		for (test in tests) {
			Sys.println('haxel: ${test}');
			Sys.println('haxe: ${HaxelTranspiler.convertVariableDecl(test)}');
			Sys.println('----------------');
		}
	 */
	public static function compileProject(project:HaxelProject, sourcePath:String, outputPath:String):HOutput {
		try {
			var output:HOutput = {success: false, data: ''};
			sourcePath = sourcePath.substr(2, sourcePath.length - 2);
			var projectPath = '';
			for (segment in sourcePath.split('/')) {
				if (segment != sourcePath.split('/')[sourcePath.split('/').length - 1]) {
					if (sourcePath.indexOf(segment) == 0)
						projectPath += '${segment.substr(1, segment.length - 1)}/';
					else
						projectPath += '${segment}/';
				}
			}
			outputPath = outputPath.substr(2, outputPath.length - 2);
			var sourceFiles = recursiveDirRead(sourcePath);
			for (file in sourceFiles) {
				if (file.endsWith('.hxl') || file.endsWith('.hxlsl')) {
					file = file.replace(sourcePath.substr(2, sourcePath.length - 2), '');
					file = file.substr(1, file.length - 1);
					file = file.split('/')[file.split('/').length - 1];
					var firstLetter = file.charAt(0);
					if (firstLetter == firstLetter.toLowerCase()) {
						output.success = false;
						output.data = 'Haxel source files must begin with an uppercase letter.';
						return output;
					}
				}
			}

			for (file in sourceFiles) {
				var transpiled = HaxelTranspiler.convertFile(File.getContent(file));
				var split = file.split('/');
				var targetFile = '';
				var targetPath = '';
				var srcSplit = sourcePath.split('/');
				for (i in 0...split.length) {
					if (srcSplit.indexOf(split[i]) == -1) {
						if (split[i].contains('.hxl') || split[i].contains('.hxlsl'))
							targetFile += '${split[i]}${split[i].contains('.hxl') || split[i].contains('.hxlsl') ? '' : '/'}';
						else {
							targetFile += '${split[i]}/';
							targetPath += '${split[i]}/';
						}
					}
				}
				FileSystem.createDirectory('$outputPath/transpiled/source/$targetPath');
				File.saveContent('$outputPath/transpiled/source/$targetFile', transpiled);
			}

			for (folder in project.copiedFolders) {
				var files = recursiveDirRead('./$projectPath/$folder');
				for (file in files) {
					var targetPath = file.replace(file.split('/')[file.split('/').length - 1], '');
					var finalSplit = [];
					var finalPath = '';
					for (segment in targetPath.split('/'))
						if (segment != '')
							finalSplit.push(segment);
					for (segmentID in 0...finalSplit.length)
						if (segmentID != 0)
							finalPath += '${finalSplit[segmentID]}/';
					// at this point I started losing my sanity. I. HATE. STRINGS.
					var why = ('$file').replace('//', '/').replace('./', '').substr(1, ('$file').replace('//', '/').replace('./', '').length - 1);
					var isThisWhatDeathFeelsLike = why.replace(why.split('/')[why.split('/').length - 1], '');
					var whyyy = '';
					var alrightStartPushing = false;
					for (segment in isThisWhatDeathFeelsLike.split('/')) {
						if (alrightStartPushing)
							whyyy += '${segment}/';
						else {
							if (segment == folder) {
								alrightStartPushing = true;
								whyyy += '${segment}/';
							}
						}
					}
					whyyy = whyyy.replace('//', '/');
					FileSystem.createDirectory('$outputPath/transpiled/$whyyy');
					File.saveBytes(('$outputPath/transpiled/$whyyy/${file.split('/')[file.split('/').length - 1]}').replace('//', '/'),
						File.getBytes(('.$file').replace('//', '/')));
				}
			}
			output.success = true;
			output.data = 'Successfully compiled project to "${outputPath.substr(2, outputPath.length - 2)}/transpiled/${project.graphicsEngine == FLIXEL ? 'export/hl/bin/' : project.graphicsEngine == HAXEL_GRAPHICS_FRAMEWORK ? 'build/' : ''}"';
			return output;
		} catch (e) {
			return {success: false, data: 'Compiler Exception! (TODO: make it fully error proof) || ${e.message} || ${e.stack}'};
		}
	}

	public static function recursiveDirRead(path:String):Array<String> {
		var files = new Array<String>();
		var dir = FileSystem.readDirectory(path);
		for (file in dir) {
			if (FileSystem.isDirectory('$path/$file'))
				files = files.concat(recursiveDirRead('$path/$file'));
			else
				files.push(('$path/$file').substr(2, '$path/$file'.length - 2));
		}
		return files;
	}
}
