package product.scripts;

import haxe.PosInfos;

class ScriptManager
{
	public static var scripts:Map<String, ScriptInfo> = [];

	static var scriptinfoStuffs:ScriptInfo = {
		variables: []
	};

	static var updateVariable = function(name:String, newValue:Dynamic) scriptinfoStuffs.variables.set(name, newValue);
	static var getVariable = function(name:String) return scriptinfoStuffs.variables.get(name);

	static var script:ScriptFile;

	static function scriptTrace(v:Dynamic, ?scriptFilePath:String, ?infos:PosInfos)
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

	public static function parseScript(scriptFilePath:String)
	{
		scriptinfoStuffs = {
			variables: []
		};

		if (!scripts.exists(scriptFilePath))
			scripts.set(scriptFilePath, scriptinfoStuffs);

		script = cast Assets.getScriptFile(scriptFilePath, false);

		for (code in script.main_function.code)
		{
			var args:Map<String, Dynamic> = [];

			var i = 1;
			FlxG.log.add('// ${code.function_name} \\\\');
			for (arg in code.args)
			{
				args.set('arg$i', arg);

				FlxG.log.notice('arg$i == ${args.get('arg$i')}');

				i++;
			}

			switch (code.function_name.toLowerCase())
			{
				case 'print':
					printCommand(args, scriptFilePath);
				case 'setvar':
					setVarCommand(args, scriptFilePath);
				default:
					scriptTrace('ERROR: UNKNOWN FUNCTION NAME WHILE PARSING: ${code.function_name}', scriptFilePath);
			}
		}
	}

	public static function printCommand(args:Map<String, Dynamic>, scriptFilePath:String)
	{
		switch (Std.string((args.get('arg1'))).toLowerCase())
		{
			case 'getvar':
				final hasValueArg = args.get('arg2') != null;
				if (hasValueArg)
				{
					scriptTrace(getVariable(args.get('arg2')), scriptFilePath);
				}
				else
				{
					scriptTrace('ERROR: MISSING "print getvar" ARG "value"', scriptFilePath);
				}

			default:
				scriptTrace(args.get('arg1'), scriptFilePath);
		}
	}

	public static function setVarCommand(args:Map<String, Dynamic>, scriptFilePath:String)
	{
		final hasNameArg = args.get('arg1') != null;
		final hasValueArg = args.get('arg2') != null;

		if (hasNameArg && hasValueArg)
		{
			if (Std.string(args.get('arg1')).toLowerCase().startsWith('math_'))
			{
				// arg 1 - math operation
				// arg 2 - [a, b ..]
				// arg 3 - variable

				updateVariable(args.get('arg3'), Std.string(mathCommand(args, scriptFilePath)));
			}
			else
				updateVariable(args.get('arg1'), args.get('arg2'));
		}
		else
		{
			if (!hasNameArg && !hasValueArg)
				scriptTrace('ERROR: MISSING "setvar" ARGS "name" & "value"', scriptFilePath);
			else if (!hasNameArg && hasValueArg)
				scriptTrace('ERROR: MISSING "setvar" ARG "name"', scriptFilePath);
			else if (hasNameArg && !hasValueArg)
				scriptTrace('ERROR: MISSING "setvar" ARG "value"', scriptFilePath);
		}
	}

	public static function mathCommand(args:Map<String, Dynamic>, scriptFilePath:String):Null<Float>
	{
		final mathValues:Array<Float> = cast args.get('arg2');
		// trace(mathValues);
		var finalval:Null<Float> = null;

		switch (Std.string(args.get('arg1')).toLowerCase().split('_')[1])
		{
			case 'plus', '+':
				for (number in mathValues)
					finalval = finalval + number;
			case 'subtract', '-':
				for (number in mathValues)
					finalval = finalval - number;
			case 'multiply', '*':
				for (number in mathValues)
					if (finalval == null)
						finalval = number
					else
						finalval = finalval * number;
			case 'divide', '/':
				for (number in mathValues)
					if (finalval == null)
						finalval = number
					else
						finalval = finalval / number;
		}

		return finalval;
	}
}
