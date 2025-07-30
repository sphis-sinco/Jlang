package;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

		if (FlxModding.mods.length > 0)
		{
			FlxG.switchState(() -> new ModMenu());
		}
		else
		{
			FlxG.switchState(() -> new Runner());
		}
	}
}
