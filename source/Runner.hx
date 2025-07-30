package;

import flixel.input.FlxInput;
import flixel.input.keyboard.FlxKey;

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
							// song = song.substring(0, song.length - 1);
						case FlxKey.SPACE:
							// song += " ";
						default:
							var keyName:String = Std.string(key);
							if (allowedKeys.contains(keyName))
							{
								keyName = FlxG.keys.pressed.SHIFT ? keyName.toUpperCase() : keyName.toLowerCase();
								// song += keyName;
								// if (song.length >= 25)
								//	song = song.substring(1);
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
