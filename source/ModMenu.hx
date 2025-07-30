package;

import flixel.group.FlxGroup;
import flixel.system.FlxModpack;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.display.BitmapData;

class ModMenu extends FlxState
{
	public static var savedSelection:Int = 0;

	var curSelected:Int = 0;

	public var page:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	public static var instance:ModMenu;

	var descriptionText:FlxText;
	var descBg:FlxSprite;
	var descIcon:FlxSprite;

	override function create()
	{
		instance = this;

		curSelected = savedSelection;

		var menuBG:FlxSprite;

		menuBG = new FlxSprite().makeGraphic(1286, 730, FlxColor.fromString("#E1E1E1"), false, "optimizedMenuDesat");

		menuBG.color = 0xff07053f;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		super.create();

		add(page);

		loadMods();

		descBg = new FlxSprite(0, FlxG.height - 320).makeGraphic(FlxG.width, 320, 0xFF000000);
		descBg.alpha = 1;
		add(descBg);

		descriptionText = new FlxText(descBg.x, descBg.y + 4, FlxG.width, "Template Description", 16);
		descriptionText.scrollFactor.set();
		add(descriptionText);

		if (FlxModding.mods.members.length < 1)
		{
			descriptionText.text = 'No mods';
			descriptionText.alignment = CENTER;
		}

		var leText:String = 'Press [SPACE] to enable / disable the currently selected mod.';

		var text:FlxText = new FlxText(0, FlxG.height - 22, FlxG.width, leText, 16);
		text.scrollFactor.set();
		add(text);

		updateSel();
	}

	function loadMods()
	{
		page.forEachExists(function(option:FlxText)
		{
			page.remove(option);
			option.kill();
			option.destroy();
		});

		var optionLoopNum:Int = 0;

		if (FlxModding.mods.members.length < 1)
			return;

		for (mod in FlxModding.mods.members)
		{
			var modOption = new FlxText(10, 0, 0, mod.name, 16);
			modOption.ID = optionLoopNum;
			page.add(modOption);
			optionLoopNum++;
		}
	}

	public var curModId = '';

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (curSelected < 0)
		{
			curSelected = page.length - 1;
			updateSel();
		}

		if (curSelected >= page.length)
		{
			curSelected = 0;
			updateSel();
		}

		var bruh = 0;

		if (page.members.length > 0)
		{
			for (x in page.members)
			{
				final x_mod = FlxModding.mods.members[x.ID];

				x.y = 10 + (bruh * 32);
				x.alpha = (x_mod.active) ? 1.0 : 0.6;
				x.color = (curSelected == x.ID) ? FlxColor.YELLOW : FlxColor.WHITE;

				if (curSelected == x.ID)
				{
					@:privateAccess
					descriptionText.color = FlxColor.WHITE;
					descriptionText.text = 'version ${x_mod.version}\n\n' + '${x_mod.description}\n\n' + 'CREDITS';

					for (person in x_mod.credits)
					{
						descriptionText.text += '\n${person.name} - ${person.title}';
					}
				}

				bruh++;
			}
		}
	}

	function updateSel() {}
}
