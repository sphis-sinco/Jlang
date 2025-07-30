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

		Runner.lt += '$str\n';

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

	public static function parseScript(scriptFilePath:String, ?restorationLine:Int = 0)
	{
		if (stored_line != 0)
			stored_line = 0;
		if (stored_scriptPath != '')
			stored_scriptPath = '';

		scriptinfoStuffs = {
			variables: []
		};

		if (!scripts.exists(scriptFilePath))
			scripts.set(scriptFilePath, scriptinfoStuffs);

		trace('Parsing script $scriptFilePath.${ProductInfo.customExtension}');

		var index = (restorationLine > 0) ? restorationLine : 0;
		if (index < 1)
		{
			// in theory there should've been no changes
			script = cast Assets.getScriptFile(scriptFilePath, false);
		}

		var ii = 0;
		for (code in script.main_function.code)
		{
			if (index > 0 && ii < index)
			{
				if (stored_input != '')
				{
					updateVariable('stored_input', stored_input);
					stored_input = '';
				}

				ii++;
				continue;
			}

			// trace(code);

			var args:Map<String, Dynamic> = [];

			var i = 1;
			FlxG.log.add('// ${code.function_name} \\\\');
			for (arg in code.args ?? [])
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
				case 'switchfile':
					parseScript('${ProductInfo.scriptPath}/${args.get('arg1')}');
					break;
				case 'clear':
					trace('Clearing output');
					Runner.lt = '';
				case 'input':
					keepRunning = false;
					stored_line = index + 1;
					stored_scriptPath = scriptFilePath;
					break;
				case 'playvideo':
					playVideoCmd(args, scriptFilePath);
				default:
					scriptTrace('ERROR: UNKNOWN FUNCTION NAME WHILE PARSING: ${code.function_name}', scriptFilePath);
			}

			index++;
			ii++;
		}
	}

	public static var keepRunning:Bool = true;

	public static var stored_input:String = '';

	public static var stored_scriptPath:String = '';
	public static var stored_line:Int = 0;

	public static function playVideoCmd(args:Map<String, Dynamic>, scriptFilePath:String)
	{
		#if !hxCodec
		lime.app.Application.current.window.alert('The "HxCodec" library cannot be found', 'HxCodec required for videos');
		return;
		#end

		final hasPathArg = args.get('arg1') != null;

		if (hasPathArg)
		{
			var video:hxcodec.flixel.FlxVideo = new hxcodec.flixel.FlxVideo();
			video.onEndReached.add(video.dispose);

			Runner.videoLayer.add(video);
			video.play(Assets.getVideoPath(args.get('arg1')));
		}
		else
		{
			if (!hasPathArg)
				scriptTrace('ERROR: MISSING "playvideo" ARG "path"', scriptFilePath);
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
				if (Std.string(args.get('arg1')).toLowerCase().startsWith('math_'))
				{
					fullMathCommand(args, scriptFilePath, d ->
					{
						scriptTrace(d, scriptFilePath);
					}, Std.string(mathCommand(args, scriptFilePath)));
				}
				else
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
				fullMathCommand(args, scriptFilePath, d ->
				{
					updateVariable(args.get('arg3'), d);
				}, Std.string(mathCommand(args, scriptFilePath)));
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

	public static function fullMathCommand(args:Map<String, Dynamic>, scriptFilePath:String, finalOperation:Dynamic->Void, finalValue:Dynamic)
	{
		// arg 1 - math operation
		// arg 2 - [a, b ..]
		// arg 3 - variable

		final hasMathOp = args.get('arg1') != null;
		final hasValues = args.get('arg2') != null;
		final hasFinalValue = finalValue != null;

		if (hasMathOp && hasValues && hasFinalValue)
			finalOperation(finalValue);
		else
		{
			if (!hasMathOp && !hasValues && !hasFinalValue)
				scriptTrace('ERROR: MISSING "setvar" ARGS "math operation" & "math variables" & "finalValue', scriptFilePath);
			else if (!hasMathOp && hasValues && hasFinalValue)
				scriptTrace('ERROR: MISSING "setvar" ARG "math operation"', scriptFilePath);
			else if (hasMathOp && !hasValues && hasFinalValue)
				scriptTrace('ERROR: MISSING "setvar" ARG "math variables"', scriptFilePath);
			else if (hasMathOp && hasValues && !hasFinalValue)
				scriptTrace('ERROR: MISSING "setvar" ARG "finalValue"', scriptFilePath);
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
