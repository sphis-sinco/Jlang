package;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

		InitManager.readInitFile(Assets.getJsonFile('init'));
		trace('${ProductInfo.title} (${ProductInfo.version}) by ${ProductInfo.credits[0]} for JLang release ${ProductInfo.jlang_release}');

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
