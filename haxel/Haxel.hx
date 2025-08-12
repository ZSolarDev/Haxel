package haxel;

import haxel.commands.*;
import thx.semver.Version;

class Haxel {
	static function main() {
		var app = new CliApp('HXLI', '0.02', false);

		app.addCommand(new HelpCommand());
		app.addCommand(new CompileCommand());

		app.setDefaultCommand(new HelpCommand());

		app.start();
	}
}
