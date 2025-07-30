import haxe.Json;

class Assets
{
	public static var IMAGE_EXT:String = 'png';
	public static var VIDEO_EXT:String = 'mp4'; // mayhaps
	public static var SOUND_EXT:String = 'wav';

	public static var SCRIPT_EXT:String = 'json';
	public static var HSCRIPT_EXT:String = 'hxc';

	// file paths

	public static function getPath(id:String)
	{
		FlxG.log.notice('getPath($id)');
		return id;
	}

	public static function getAssetPath(id:String)
		return getPath('assets/$id');

	public static function getDataPath(id:String)
		return getAssetPath('data/$id');

	public static function getImagePath(id:String)
		return getAssetPath('images/$id.$IMAGE_EXT');

	public static function getVideoPath(id:String)
		return getAssetPath('videos/$id.$VIDEO_EXT');

	public static function getMusicPath(id:String)
		return getAssetPath('music/$id.$SOUND_EXT');

	public static function getSoundPath(id:String)
		return getAssetPath('sounds/$id.$SOUND_EXT');

	// file content

	public static function getFileTextContent(id:String, ?dataFolder:Bool = true)
	{
		var path = getAssetPath('$id');
		if (dataFolder)
			path = getDataPath('$id');

		return FlxModding.system.getText(path);
	}

	public static function getTextFile(id:String, ?dataFolder:Bool = true)
		return getFileTextContent('$id.txt', dataFolder);

	public static function getFileJsonContent(id:String, ?dataFolder:Bool = true)
		return Json.parse(getFileTextContent(id, dataFolder));

	public static function getJsonFile(id:String, ?dataFolder:Bool = true)
		return getFileJsonContent('$id.json', dataFolder);

	public static function getScriptFile(id:String, ?dataFolder:Bool = true)
		return getFileJsonContent('$id.$SCRIPT_EXT', dataFolder);

	public static function getImage(id:String, ?imageFolder:Bool = true)
	{
		var path = getAssetPath('$id.$IMAGE_EXT');
		if (imageFolder)
			path = getImagePath(id);

		return FlxModding.system.getBitmapData(path);
	}
}
