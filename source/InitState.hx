package;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

		#if sys
		for (video in sys.FileSystem.readDirectory('assets/videos'))
		{
			trace('Hey a video: $video');
			var videoObj:FlxVideo = new FlxVideo();
			videoObj.cacheAsBitmap = true;
			videoObj.volume = 0;
			videoObj.play(Assets.getVideoPath(video));
			videoObj.dispose();
		}
		#end

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
