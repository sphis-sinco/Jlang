package;

class Runner extends FlxState
{
	override public function create()
	{
		trace(Assets.getJsonFile('init'));

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
