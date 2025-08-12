package haxel.commands;

import comma.CliApp;
import comma.Command;
import comma.ParsedOptions;

class HelpCommand extends Command {
	override function getName():String {
		return 'help';
	}

	override function getDescription():String {
		return 'Displays the commands and their usages. Usage:\n\thaxel help';
	}

	override function onExecuted(app:CliApp, value:Array<String>, options:ParsedOptions) {
		app.printHelp();
	}
}
