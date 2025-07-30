package;

import flixel.input.FlxInput;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Runner extends FlxState
{
	public var leftText:FlxText;
	public var inputText:FlxText;

	public static var lt:String = '';

	public var it:String = '';

	override public function create()
	{
		lt = '';
		it = '';

		leftText = new FlxText(0, 0, Std.int(FlxG.width / 2), '', 16);
		leftText.color = FlxColor.WHITE;
		add(leftText);

		inputText = new FlxText(Std.int(FlxG.width / 2), 0, Std.int(FlxG.width / 2), '', 16);
		inputText.color = FlxColor.WHITE;
		add(inputText);

		ScriptManager.parseScript('${ProductInfo.scriptPath}/${ProductInfo.mainScriptName}');

		super.create();
	}

	override public function update(elapsed:Float)
	{
		leftText.text = lt;
		inputText.text = '> $it';
		handleKeyInput(elapsed);

		FlxG.watch.addQuick('leftText.y', leftText.y);

		if (FlxG.keys.pressed.DOWN)
		{
			leftText.y -= LEFT_TEXT_VERTICAL_MOVING;
		}
		if (FlxG.keys.pressed.UP)
		{
			leftText.y += LEFT_TEXT_VERTICAL_MOVING;
		}
		final heightMax = leftText.height * 0.9;
		if (leftText.y < -heightMax)
			leftText.y = -heightMax;
		if (leftText.y > 0)
			leftText.y = 0;

		super.update(elapsed);
	}

	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 ';
	var keyTime:Float = 0;

	final LEFT_TEXT_VERTICAL_MOVING = 15;

	final MAX_KEYTIME:Float = 0.15;
	final START_KEYTIME_DEFAULT:Float = 0.05;
	final START_KEYTIME_ALPHABET:Float = 0.1;

	function handleKeyInput(elapsed:Float)
	{
		var alphabetKey = function(keyName:String)
		{
			return 'abcdefghijklmnopqrstuvwxyz'.contains(keyName.toLowerCase());
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			if (!ScriptManager.keepRunning)
			{
				ScriptManager.stored_input = lt;
				ScriptManager.keepRunning = true;

				ScriptManager.parseScript(ScriptManager.stored_scriptPath, ScriptManager.stored_line);
			}

			it = '';
		}
		else if (FlxG.keys.firstPressed() != FlxKey.NONE)
		{
			if (keyTime == 0 || keyTime > MAX_KEYTIME)
			{
				var keyPressed:Array<FlxInput<FlxKey>> = FlxG.keys.getIsDown();

				if (keyTime > MAX_KEYTIME)
					keyTime = alphabetKey(Std.string(FlxG.keys.getIsDown()[0])) ? START_KEYTIME_ALPHABET : START_KEYTIME_DEFAULT;

				for (i in keyPressed)
				{
					var key:FlxKey = i.ID;
					var keyName:String = Std.string(key);
					switch (key)
					{
						case ZERO:
							keyName = '0';
						case ONE:
							keyName = '1';
						case TWO:
							keyName = '2';
						case THREE:
							keyName = '3';
						case FOUR:
							keyName = '4';
						case FIVE:
							keyName = '5';
						case SIX:
							keyName = '6';
						case SEVEN:
							keyName = '7';
						case EIGHT:
							keyName = '8';
						case NINE:
							keyName = '9';
						case BACKSPACE, SPACE:
							keyName = ' ';

						default:
							// LEAVE ME ALONE
					}

					if (!allowedKeys.contains(keyName))
						return;

					switch (key)
					{
						case BACKSPACE:
							it = it.substring(0, it.length - 1);
						default:
							{
								if (alphabetKey(keyName))
									keyName = FlxG.keys.pressed.SHIFT ? keyName.toUpperCase() : keyName.toLowerCase();
								it += keyName;
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
