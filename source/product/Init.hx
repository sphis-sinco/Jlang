package product;

import openfl.Lib;

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
		ProductInfo.customExtension = file.scripts.customExtension ?? 'json';
		Assets.SCRIPT_EXT = ProductInfo.customExtension;

		ProductInfo.mainScriptName = file.scripts.mainScriptName ?? 'main';
		ProductInfo.scriptPath = file.scripts.scriptPath ?? 'data/scripts';

		ProductInfo.credits = file.product.credits ?? ['Unknown'];
		ProductInfo.jlang_release = file.product.jlang_release ?? Std.parseInt(Lib.application.meta.get('version'));
		ProductInfo.title = file.product.title ?? 'Unknown JLand Project';
		ProductInfo.version = file.product.version ?? '0.0.0';
	}
}
