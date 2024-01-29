package windowblinds;

import openfl.ui.MouseCursor;
import openfl.ui.Mouse;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Lib;
import flixel.util.FlxColor;
import flash.display.Shape;
import format.ico.Reader;
import haxe.Timer;
import windowblinds.WindowblindButton;
import windowblinds.WindowblindNatives;
import windowblinds.WindowblindDragFlags;
import openfl.events.Event;
import openfl.events.MouseEvent;

// holy hell this code is hot garbage
// someone remind me to refactor this later
@:access(openfl.ui.MouseCursor) // IM COME YOU
@:access(lime.ui.Window)
class Windowblinds extends Sprite {

	public var doTimeout:Bool = true;
	public var forcedHide:Bool = false;
	public var drawAlpha:Float = 0.2;
	public var dragging(default, null):Bool = false;
	public var resizing(default, null):Bool = false;
	public var resizeFlag:Int = WindowblindDragFlags.NONE;

	public var windowPtr:WindowblindWindow;

	private var borderShape:Shape;
	private var captionShape:Shape;

	private var captionContainer:Sprite;
	private var captionButtons:Sprite;

	private var captionText:TextField;
	private var captionIcon:Bitmap;

	private var minimizeButton:WindowblindButton;
	private var maximizeButton:WindowblindButton;
	private var closeButton:WindowblindButton;

	private var lastClickTime:Float = 0;

	private var dragOffset:Array<Float> = [0, 0];
	private var resizeBools:Array<Bool> = [false, false];
	private var resizeAnchors:Array<Int> = [0, 0];
	private var resizeSize:Array<Int> = [0, 0];
	private var resizePos:Array<Int> = [0, 0];
	private var resizePosBalls:Array<Int> = [0, 0];

	private var hideTimer:Timer;

	@:allow(windowblinds.WindowblindButton)
	private static var elapsed:Float = 0;

	private static final doubleClickTime:Int = WindowblindNatives.getDoubleClickTime();
	private static final frameColorPath:String = 'SOFTWARE\\Microsoft\\Windows\\DWM';
	private static final frameColorValue:String = 'AccentColor';

	public static var borderColor(default, null):FlxColor = 0xFF99008c;

	private var targetWindow:lime.ui.Window;
	public function new(target:lime.ui.Window, ?borderTitle:String, ?hasIcon:Bool = true, ?hasButtons:Bool = true) {
		targetWindow = target;
		targetWindow.borderless = true;
		super();
		borderShape = new Shape();

		captionContainer = new Sprite();
		captionContainer.x = captionContainer.y = 8;

		try borderColor = WindowblindNatives.getRealAccentColour() catch(e)
			try borderColor = Std.int(WindowblindNatives.getAccentColour()) catch(estrogen)
				try borderColor = WindowblindNatives.getSystemColour(10) catch(estrogen) {}
		
		borderColor = borderColor.setRGB(borderColor.blue, borderColor.green, borderColor.red);
		borderColor = borderColor.to24Bit();

		windowPtr = WindowblindNatives.getHwndFromCurrentWindow();
		WindowblindNatives.setShadow(windowPtr, true);
		captionShape = new Shape();
		captionButtons = new Sprite();

		captionIcon = new Bitmap(Paths.image('icon').bitmap, AUTO, false);
		captionIcon.width = 19;
		captionIcon.height = 19;
		captionIcon.x = 10;
		captionIcon.y = 35 / 2 - captionIcon.height / 2;

		captionText = new TextField();
		captionText.text = (borderTitle != null ? borderTitle : targetWindow.application.meta.get('name'));
		captionText.defaultTextFormat = new TextFormat(Paths.font('segoeui.ttf'), 16, 0xFFFFFF);
		captionText.x = (hasIcon ? 30 : 10);
		captionText.y = 2;
		captionText.selectable = false;
		captionText.mouseEnabled = false;
 
		addChild(borderShape);

		captionContainer.addChild(captionShape);

		if (hasIcon) captionContainer.addChild(captionIcon);
		captionContainer.addChild(captionText);

		addChild(captionContainer);

		if (hasButtons) captionContainer.addChild(captionButtons);

		captionButtons.scaleX = 1.2;
		captionButtons.scaleY = 1.2;
		var balls = ['close', 'maximize', 'minimize'];
		balls.reverse();
		for (bitmap in balls) {
			var bitmapBalls:Bitmap = new Bitmap(Paths.image('gameframe/$bitmap').bitmap, ALWAYS, false);
			var buttonSprite:WindowblindButton = new WindowblindButton(bitmapBalls, false, (bitmap == 'close' ? 0xFF0000 : 0xFFFFFF));

			// buttonArray.push(buttonSprite);
			buttonSprite.x = 45 * balls.indexOf(bitmap);
			captionButtons.addChild(buttonSprite);

			buttonSprite.onUp = () ->  
				switch (bitmap) {
					case 'close': targetWindow.onClose.dispatch();
					case 'minimize': targetWindow.minimized = !targetWindow.minimized;
					case 'maximize': targetWindow.maximized = !targetWindow.maximized;
					default: throw 'whar ???';
				} 
		}

		timeout();
		redraw();

		var lastTime:Float = 0;
		targetWindow.stage.addEventListener(Event.ENTER_FRAME, (_) -> elapsed = Lib.getTimer() - lastTime);

		// dragging
		captionContainer.addEventListener(MouseEvent.MOUSE_DOWN, (evnt) -> {
			if (evnt.stageX >= captionButtons.x + captionContainer.x) return; // OPENFL IS STUPID !!!!!
			dragging = true;
			dragOffset = [evnt.localX, evnt.localY];
		});
		captionContainer.addEventListener(MouseEvent.MOUSE_UP, (_) -> dragging = false);

		targetWindow.stage.addEventListener(Event.ENTER_FRAME, (evnt) -> {
			if (!dragging) return;
			targetWindow.maximized = false;
			var xBalls = 0, yBalls = 0;
			WindowblindNatives.getMousePos(xBalls, yBalls);
			targetWindow.move(xBalls - Std.int(dragOffset[0]) - 8, yBalls - Std.int(dragOffset[1]) - 8);
		});
		
		// border timeout
		targetWindow.stage.addEventListener(MouseEvent.MOUSE_MOVE, (_) -> timeout());

		targetWindow.onResize.add((x, y) -> redraw());

		// stupid code for changing out the maximize button bitmap
		targetWindow.onMaximize.add(() -> {
			// cast(buttonArray[1].getChildAt(1), Bitmap).bitmapData = Paths.image('gameframe/unmaximize').bitmap;
			WindowblindNatives.setShadow(windowPtr, false);
		});

		targetWindow.onRestore.add(() -> {
			// cast(buttonArray[1].getChildAt(1), Bitmap).bitmapData = Paths.image('gameframe/maximize').bitmap;
			WindowblindNatives.setShadow(windowPtr, true);
		});

		if (!target.resizable) return;

		captionContainer.addEventListener(MouseEvent.CLICK, (_) -> {
			var curTime = Lib.getTimer();
			if ((curTime - lastClickTime) < doubleClickTime) {
				targetWindow.stage.window.maximized = !targetWindow.stage.window.maximized;
				lastClickTime = 0;
				return;
			} 
			lastClickTime = curTime;
		});

		targetWindow.stage.addEventListener(MouseEvent.MOUSE_MOVE, (evnt) -> {
			if (!resizing) {
				resizeFlag = WindowblindDragFlags.NONE;
				var targetCursor:MouseCursor = AUTO;
				if (evnt.stageX <= 4) resizeFlag |= WindowblindDragFlags.LEFT;
				if (evnt.stageX >= targetWindow.width - 4) resizeFlag |= WindowblindDragFlags.RIGHT;
				if (evnt.stageY <= 4) resizeFlag |= WindowblindDragFlags.TOP;
				if (evnt.stageY >= targetWindow.height - 4) resizeFlag |= WindowblindDragFlags.BOTTOM;
				switch (resizeFlag) {
					case 1 | 4: targetCursor = __RESIZE_WE;
					case 2 | 8: targetCursor = __RESIZE_NS;
					case 3 | 12: targetCursor = __RESIZE_NWSE;
					case 6 | 9: targetCursor = __RESIZE_NESW;
					default:
				}
				Mouse.cursor = targetCursor;

				var xBalls = 0, yBalls = 0;
				WindowblindNatives.getMousePos(xBalls, yBalls);
				resizePos = [xBalls, yBalls];

				resizeSize = [targetWindow.width, targetWindow.height];
				resizePosBalls = [targetWindow.x, targetWindow.y, 
				targetWindow.x + targetWindow.width, targetWindow.y + targetWindow.height];
			}
		});

		targetWindow.stage.addEventListener(MouseEvent.MOUSE_DOWN, (_) -> if (resizeFlag != 0) resizing = true);
		targetWindow.stage.addEventListener(MouseEvent.MOUSE_UP, (_) -> resizing = false);

		targetWindow.stage.addEventListener(Event.ENTER_FRAME, (_) -> {
			var xBalls = 0, yBalls = 0;
			WindowblindNatives.getMousePos(xBalls, yBalls);
			if (resizing) {
				switch (resizeFlag) {
					case WindowblindDragFlags.LEFT:
						var thing:Int = xBalls - (resizePos[0] - resizePosBalls[0]);
						targetWindow.x = thing;
						targetWindow.width = resizePosBalls[2] - thing;
					case WindowblindDragFlags.RIGHT:
						targetWindow.width = resizeSize[0] - resizePos[0] + xBalls;
					case WindowblindDragFlags.BOTTOM:
						targetWindow.height = resizeSize[1] - resizePos[1] + yBalls;
					case WindowblindDragFlags.TOP:
						var thing:Int = yBalls - (resizePos[1] - resizePosBalls[1]);
						targetWindow.y = thing;
						targetWindow.height = resizePosBalls[3] - thing;
					case WindowblindDragFlags.BOTTOMRIGHT:
						targetWindow.resize(resizeSize[0] - resizePos[0] + xBalls, resizeSize[1] - resizePos[1] + yBalls);
					case WindowblindDragFlags.BOTTOMLEFT:
						var thing:Int = xBalls - (resizePos[0] - resizePosBalls[0]);
						targetWindow.x = thing;
						targetWindow.resize(resizePosBalls[2] - thing, resizeSize[1] - resizePos[1] + yBalls);
					case WindowblindDragFlags.TOPLEFT:
						var thing:Int = xBalls - (resizePos[0] - resizeSize[0]);
						var thingballs:Int = yBalls - (resizePos[1] - resizeSize[1]);
						targetWindow.move(thing, thingballs);
						targetWindow.resize(resizePosBalls[2] - thing, resizePosBalls[3] - thingballs);
					default:
				}
			}
		});
	}

	public function timeout() {
		if (!doTimeout) {
			Mouse.show(); 
			visible = true; 
			return;
		}

		if (!forcedHide) {
			Mouse.show(); 
			visible = true;
			dispatchEvent(new Event('show'));
			hideTimer?.stop();
			hideTimer = Timer.delay(() -> {
				Mouse.hide();
				visible = false;
				dispatchEvent(new Event('hide'));
			}, 1500);
			return;
		}

		Mouse.hide();
		visible = false;
	}

	public function redraw() {
		borderShape.graphics.clear();
		captionShape.graphics.clear();

		borderShape.graphics.lineStyle(2, borderColor, drawAlpha, true, NONE, SQUARE, MITER, 1.414);
		borderShape.graphics.drawRect(4, 4, targetWindow.width - 8, targetWindow.height - 8);

		captionShape.graphics.beginFill(borderColor, drawAlpha);
		captionShape.graphics.drawRoundRect(0, 0, targetWindow.width - 16, 35, 5);
		captionText.width = targetWindow.width - 16 - 30 - captionButtons.width;
		captionButtons.x = targetWindow.width - 16 - captionButtons.width;
	}

}