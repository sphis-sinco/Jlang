package product.scripts;

import haxe.Log;
import haxe.PosInfos;

class ScriptManager
{
	public static function parseScript(scriptFilePath:String)
	{
		final script:ScriptFile = cast Assets.getJsonFile(scriptFilePath, false);

		var scriptTrace = function(v:Dynamic, ?infos:PosInfos)
		{
			var str = '[${script.logging.prefix ?? scriptFilePath}] $v';
			#if js
			if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null)
				(untyped console).log(str);
			#elseif lua
			untyped __define_feature__("use._hx_print", _hx_print(str));
			#elseif sys
			Sys.println(str);
			#else
			throw new haxe.exceptions.NotImplementedException();
			#end
		}

		for (code in script.main_function.code)
		{
			switch (code.function_name.toLowerCase())
			{
				case 'print':
					scriptTrace(code.args[0]);
				default:
					trace('UNKNOWN FUNCTION NAME WHILE PARSING: ${code.function_name}');
			}
		}
	}
}
