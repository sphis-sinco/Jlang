package;

class Runner extends FlxState
{
	override public function create()
	{
		ScriptManager.parseScript('${ProductInfo.scriptPath}/${ProductInfo.mainScriptName}');

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
