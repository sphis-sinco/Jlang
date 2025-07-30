package;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

		InitManager.readInitFile(Assets.getJsonFile('init'));

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
