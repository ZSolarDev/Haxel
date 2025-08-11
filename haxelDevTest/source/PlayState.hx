package;

import haxel.Tests;
import flixel.FlxState;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();
        Tests.main();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
