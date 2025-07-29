package;

class InitState extends FlxState
{
        override function create() {
                super.create();

		InitManager.readInitFile(Assets.getJsonFile('init'));
        }
}