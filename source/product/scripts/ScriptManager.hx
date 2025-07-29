package product.scripts;

import haxe.PosInfos;

class ScriptManager
{
	public static var scripts:Map<String, ScriptInfo> = [];

	public static function parseScript(scriptFilePath:String)
	{
		var scriptinfoStuffs:ScriptInfo = {};

		if (!scripts.exists(scriptFilePath))
		{
			scripts.set(scriptFilePath, scriptinfoStuffs);
		}

		final script:ScriptFile = cast Assets.getScriptFile(scriptFilePath, false);

		var updateVariable = function(name:String, newValue:Dynamic)
		{
			scriptinfoStuffs.variables.set(name, newValue);
		}

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
			var args:Map<String, Dynamic> = [];

			var i = 0;
			for (arg in code.args)
			{
				args.set('arg$i', arg);
				i++;
			}

			switch (code.function_name.toLowerCase())
			{
				case 'print':
					switch (Std.string((args.get('arg1'))).toLowerCase())
					{
						case 'getvar':
							final hasValueArg = args.get('arg2') == null;
							if (hasValueArg) scriptTrace(args.get('arg2')); else scriptTrace('ERROR: MISSING "print getvar" ARG "value"');

						default:
							scriptTrace(args.get('arg1'));
					}
				case 'setvar':
					final hasNameArg = args.get('arg1') == null;
					final hasValueArg = args.get('arg2') == null;

					if (hasNameArg && hasValueArg)
					{
						updateVariable(args.get('arg1'), args.get('arg2'));
					}
					else
					{
						if (!hasNameArg && !hasValueArg)
							scriptTrace('ERROR: MISSING "setvar" ARGS "name" & "value"');
						else if (!hasNameArg && hasValueArg)
							scriptTrace('ERROR: MISSING "setvar" ARG "name"');
						else if (hasNameArg && !hasValueArg)
							scriptTrace('ERROR: MISSING "setvar" ARG "value"');
					}
				default:
					scriptTrace('ERROR: UNKNOWN FUNCTION NAME WHILE PARSING: ${code.function_name}');
			}
		}
	}
}
