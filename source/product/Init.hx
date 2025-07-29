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
		ProductInfo.customExtension = file.scripts.customExtension;
		ProductInfo.mainScriptName = file.scripts.mainScriptName;
		ProductInfo.scriptPath = file.scripts.scriptPath;

		ProductInfo.credits = file.product.credits;
		ProductInfo.jlang_release = file.product.jlang_release;
		ProductInfo.title = file.product.title;
		ProductInfo.version = file.product.version;
	}
}
