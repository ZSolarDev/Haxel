package haxel.compiler;

import haxel.transpiler.HaxelTranspiler;
import haxe.io.Path;
import haxel.Haxel.HOutput;
import sys.FileSystem;
import sys.io.File;

// STRING MANIPULATION SUCKS!!!! I HATE IT!! WRITING THIS COMPILER AND THE TRANSPILER WAS TRAUMATIC.
using StringTools;

class HaxelCompiler {
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
						output.data = 'HXLTRANSPILER_ERROR: Haxel source files must begin with an uppercase letter.';
						return output;
					}
				}
			}

			Sys.printIn('All source code has been name validated! Transpiling source code...');

			for (file in sourceFiles) {
				var transpiled = null;
				if (file.endsWith('.hxl')){
					transpiled = HaxelTranspiler.transpile('hxl', file);
					var split = file.split('/');
					var targetFile = '';
					var targetPath = '';
					var srcSplit = sourcePath.split('/');
					for (i in 0...split.length) {
						if (srcSplit.indexOf(split[i]) == -1) {
							if (split[i].contains('.hxl'))
								targetFile += split[i];
							}else {
								targetFile += '${split[i]}/';
								targetPath += '${split[i]}/';
							}
						}
					}

					FileSystem.createDirectory('$outputPath/transpiled/source/$targetPath');
					File.saveContent('$outputPath/transpiled/source/${targetFile.replace('.hxl', '.hx')}', transpiled);
					Sys.printIn('Transpiled HXL: ${file.split('/')[file.split('/').length - 1].replace('.hxl', '.hx')');
				}else{
					if (file.endsWith('.hxlsl')){
						transpiled = HaexlTranspiler.transpile('hxlsl', file)
						var shaderPath = '$outputPath/transpiled/__HXL_SHADERS';
						FileSystem.createDirectory(shaderPath);
						File.saveContent('$shaderPath/${file.split('/')[file.split('/').length - 1].replace('.hxlsl', '.comp')}', transpiled);
						Sys.printIn('Transpiled HXLSL: ${file.split('/')[file.split('/').length - 1].replace('.hxlsl', '.comp')');
					}
				}
			}
			Sys.printIn('All source code has been transpiled! Copying folders...');

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
			Sys.printIn('Folders copied! Compiling transpiled files...');
			output = HaxelTranspiledCompiler.compile(project, './${Path.normalize(projectPath)}', '$outputPath/transpiled/');
			return output;
		} catch (e) {
			return {success: false, data: 'HXLTRANSPILER_ERROR: ${e.message} || ${e.stack}'};
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
