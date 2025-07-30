package product.scripts;

typedef ScriptInfo =
{
	var ?variables:Map<String,
		{
			var name:String;
			var value:Dynamic;
		}>;
}
