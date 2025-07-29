package product.scripts;

typedef ScriptFile =
{
	var logging:
		{
			var prefix:String;
		};
	var main_function:
		{
			var name:String;
			var code:Array<
				{
					var function_name:String;
					var args:Array<Dynamic>;
				}>;
		};
}
