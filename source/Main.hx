package;

import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		FlxModding.init();
		
		super();
		addChild(new FlxGame(0, 0, InitState));
	}
}
