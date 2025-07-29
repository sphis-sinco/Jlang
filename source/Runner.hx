package;

class Runner extends FlxState
{
	override public function create()
	{
		trace(FlxModding.system.getText('assets/data/init.json'));

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
