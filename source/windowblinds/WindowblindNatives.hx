package windowblinds;

typedef WindowblindWindow = hl.Abstract<"HWND">;

@:hlNative('windowblinds')
class WindowblindNatives {
	public static function getMousePos(x:hl.Ref<Int>, y:hl.Ref<Int>):Void {}
	public static function getDoubleClickTime():Int return 0;
	public static function getSystemColour(index:Int):Int return 0;
	public static function getAccentColour():hl.F64 return 0;
	public static function getRealAccentColour():Int return 0;

	public static function getHwndFromCurrentWindow():WindowblindWindow return null;

	public static function setShadow(window:WindowblindWindow, enabled:Bool):Void {}
	public static function getShadow(window:WindowblindWindow):Bool return false;
	public static function enableAcrylic(window:WindowblindWindow, coluor:Int):Void {};
	public static function enableBlur(window:WindowblindWindow):Void {};
	public static function disableEffects(window:WindowblindWindow):Void {};
}