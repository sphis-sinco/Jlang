package;

import flixel.input.FlxInput;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Runner extends FlxState
{
	public var inputText:FlxText;
	public var it:String;

	override public function create()
	{
		it = '';

		inputText = new FlxText(Std.int(FlxG.width / 2), 0, Std.int(FlxG.width / 2), "", 16);
		inputText.color = FlxColor.WHITE;
		add(inputText);

		ScriptManager.parseScript('${ProductInfo.scriptPath}/${ProductInfo.mainScriptName}');

		super.create();
	}

	override public function update(elapsed:Float)
	{
		inputText.text = it;
		handleKeyInput(elapsed);

		super.update(elapsed);
	}

	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-_+={}[]|\\;:"\',./<>?';
	var keyTime:Float = 0;

	function handleKeyInput(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER) {}
		else if (FlxG.keys.firstPressed() != FlxKey.NONE)
		{
			if (keyTime == 0 || keyTime > 0.3)
			{
				if (keyTime > 0.3)
					keyTime = 0.25;
				var keyPressed:Array<FlxInput<FlxKey>> = FlxG.keys.getIsDown();
				for (i in keyPressed)
				{
					var key:FlxKey = i.ID;
					switch (key)
					{
						case FlxKey.BACKSPACE:
							it = it.substring(0, it.length - 1);
						case FlxKey.SPACE:
							it += " ";
						default:
							var keyName:String = Std.string(key);
							if (allowedKeys.contains(keyName))
							{
								keyName = FlxG.keys.pressed.SHIFT ? keyName.toUpperCase() : keyName.toLowerCase();
								it += keyName;
								if (it.length >= 25)
									it = it.substring(1);
							}
					}
				}
			}
			keyTime += elapsed;
		}
		else
		{
			keyTime = 0;
		}
	}
}
