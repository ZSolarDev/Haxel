package haxel.compiler;

import haxe.io.Path;
import haxel.Haxel.HOutput;
import haxel.Haxel.Verbose;
import haxel.transpiler.HaxelTranspiler;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

using StringTools;

// STRING MANIPULATION SUCKS!!!! I HATE IT!! WRITING THIS COMPILER AND THE TRANSPILER WAS TRAUMATIC.
class HaxelCompiler {
	public static function compileProject(project:HaxelProject, sourcePath:String, outputPath:String, test:Bool = false, verbose:Verbose):HOutput {
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

			Sys.println('All source code has been name validated! Initializing modules...${verbose.plus ? '\n' : ''}');

			var libFiles = sourceFiles;
			if (project.graphicsEngine == FLIXEL && !project.libraries.contains('flixel'))
				project.libraries.push('flixel');
			project.libraries.push('format');
			for (haxelib in project.libraries) {
				var p = new Process('haxelib', ['path', haxelib], false);
				var output = p.stdout.readAll().toString();
				p.close();
				var libPath = output.split('\n').shift().trim();
				libFiles = libFiles.concat(recursiveDirRead(libPath));
			}
			HaxelTranspiler.initModule('hxl', libFiles, verbose, project);

			Sys.println('${verbose.plus ? '\n' : ''}Modules initialized! Transpiling source code...${verbose.enabled ? '\n' : ''}');
			for (file in sourceFiles) {
				var transpiled = null;
				if (file.endsWith('.hxl')) {
					transpiled = HaxelTranspiler.transpile('hxl', file);
					var srcNorm = Path.normalize(sourcePath);
					if (!srcNorm.endsWith("/"))
						srcNorm += "/";

					var relativePath = file.substr(srcNorm.length);
					var hxPath = relativePath.substr(0, relativePath.length - 4) + ".hx";

					FileSystem.createDirectory(Path.directory('$outputPath/transpiled/source/$hxPath'));
					File.saveContent('$outputPath/transpiled/source/$hxPath', transpiled.data);

					if (verbose.enabled)
						Sys.println('Transpiled HXL: ${Path.withoutDirectory(hxPath)}');
				} else {
					if (file.endsWith('.hxlsl')) {
						transpiled = HaxelTranspiler.transpile('hxlsl', file);
						var shaderPath = '$outputPath/transpiled/__HXL_SHADERS';
						FileSystem.createDirectory(shaderPath);
						File.saveContent('$shaderPath/${file.split('/')[file.split('/').length - 1].replace('.hxlsl', '.comp')}', transpiled.data);
						if (verbose.enabled)
							Sys.println('Transpiled HXLSL: ${file.split('/')[file.split('/').length - 1].replace('.hxlsl', '.comp')}');
					}
				}
			}
			Sys.println('${verbose.enabled ? '\n' : ''}All source code has been transpiled! Copying folders...');

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
						File.getBytes(('./$file').replace('//', '/')));
				}
			}
			Sys.println('Folders copied! Injecting Haxel Standard Library...${verbose.plus ? '\n' : ''}');
			output = HaxelPostTranspiler.compileProject(project, './${Path.normalize(projectPath)}', '$outputPath/transpiled/', outputPath, test, verbose);
			return output;
		} catch (e) {
			return {success: false, data: 'HXLTRANSPILER_ERROR: ${e.message} || ${e.stack}'};
		}
	}

	public static function recursiveDirRead(path:String):Array<String> {
		var files = new Array<String>();
		var dir = FileSystem.readDirectory(path);
		var inDrive = path.charAt(1) == ':';
		var drive = inDrive ? path.charAt(0) + ':' : '';
		for (file in dir) {
			if (FileSystem.isDirectory('$path/$file'))
				files = files.concat(recursiveDirRead('$path/$file'));
			else
				files.push(('$drive${path.replace('//', '/')}/$file').substr(2, '$drive${path.replace('//', '/')}/$file'.length - 2));
		}
		return files;
	}
}
