package product;

typedef InitJson =
{
	var scripts:
		{
			var scriptPath:String;
			var mainScriptName:String;
			var customExtension:String;
		};
	var product:
		{
			var title:String;
			var version:String;
			var jlang_release:Int;
			var credits:Array<String>;
		};
}

class InitManager
{
	public static function readInitFile(file:InitJson)
	{
		// TODO \\
	}
}
