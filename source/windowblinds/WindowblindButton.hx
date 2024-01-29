package windowblinds;

import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.DisplayObject;
import windowblinds.Windowblinds;
import openfl.events.Event;
import openfl.events.MouseEvent;

class WindowblindButton extends Sprite {
	public var label:DisplayObject;

	public function new(label:DisplayObject, hasBg:Bool = false, hightlightColor:Int = 0xFFFFFF) {
		super();

		if (hasBg) {
			graphics.beginFill(Windowblinds.borderColor, 0.2);
			graphics.drawRoundRect(0, 0, label.width, label.height, 5);	
			graphics.endFill();
		}

		var highlight:Shape = new Shape();
		highlight.graphics.beginFill(hightlightColor, 1);
		highlight.graphics.drawRoundRect(0, 0, label.width, label.height, 5);	
		highlight.graphics.endFill();
		addChild(highlight);
		addChild(label);

		var targetAlpha:Float = 0;
		var fade:Float = 0;

		addEventListener(MouseEvent.MOUSE_OVER, (_) -> {targetAlpha = 1; onHover();});
		addEventListener(MouseEvent.MOUSE_OUT, (_) -> {targetAlpha = 0; onLeave();});
		addEventListener(MouseEvent.MOUSE_DOWN, (_) -> {targetAlpha = fade = 0.7; onDown();});
		addEventListener(MouseEvent.MOUSE_UP, (_) -> onUp());
 
		addEventListener(Event.ENTER_FRAME, (_) -> {
			if (targetAlpha > 0) fade = Math.min(fade + Windowblinds.elapsed / 0.2, targetAlpha)
			else fade = Math.max(fade - Windowblinds.elapsed / 0.2, 0);

			highlight.alpha = fade * 0.3;
		});
	}

	dynamic public function onHover() {}
	dynamic public function onLeave() {}
	dynamic public function onDown() {}
	dynamic public function onUp() {}
}