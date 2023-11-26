package;

import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.util.FlxColor;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import openfl.display.DisplayObject;
import lime.app.Application;
import flash.display.Shape;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;
import openfl.ui.MouseCursor;
import openfl.ui.Mouse;
import motion.Actuate;
import motion.easing.Expo;
import sys.thread.Thread;
import lime.graphics.RenderContextType;

import haxe.Timer;

#if desktop
import Discord.DiscordClient;
#end

//crash handler stuff
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;	
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

using StringTools;

@:access(openfl.display.Stage)
class Main extends Sprite
{
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: DumbassWaringScreenState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public static var fpsVar:FPS;
	public static var border:WindowBorder;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
		Lib.current.addChild(new Main());

	public function new()
	{
		super();
		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, init);

		setupGame();
	}

	private function setupGame():Void
	{
		stage.onError.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		hl.Api.setErrorHandler(onCrash);

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0) {
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}
	
		PlankPrefs.loadDefaultKeys();
		addChild(new FlxGame(game.width, game.height, game.initialState, game.framerate, game.framerate, game.skipSplash, game.startFullscreen));

		FlxG.game.addEventListener(MouseEvent.MOUSE_DOWN, (evnt) -> if (border.resizeFlag != Main.WindowBlindsDragFlags.NONE) evnt.stopImmediatePropagation());
		FlxG.game.addEventListener(MouseEvent.MOUSE_UP, (evnt) -> if (border.resizeFlag != Main.WindowBlindsDragFlags.NONE) evnt.stopImmediatePropagation());
		FlxG.mouse.useSystemCursor = true;

		PlayerSettings.init();
		FlxG.save.bind('funkin', CoolUtil.getSavePath());
		PlankPrefs.loadPrefs();
		Highscore.load();

		FlxG.stage.addChild(fpsVar = new FPS(10, 3));
		FlxG.stage.align = "tl";
		FlxG.stage.scaleMode = StageScaleMode.NO_SCALE;
		if(fpsVar != null)
			fpsVar.visible = PlankPrefs.data.showFPS;

		#if desktop
		if (!DiscordClient.isInitialized) {
			DiscordClient.initialize();
			Application.current.window.onClose.add(function() {
				DiscordClient.shutdown();
			});
		}
		#end

		FlxG.stage.addChild(border = new WindowBorder(FlxG.stage.window));
		FlxG.sound.soundTray.parent.removeChild(FlxG.sound.soundTray);
		border.addChild(FlxG.sound.soundTray); // terrible fix but eh fuck it
		// border.alpha = 0.5;
		border.addEventListener('show', (evnt) -> {
			fpsVar.x = 8;
			fpsVar.y = 8 + 35 + 2;
		});
		border.addEventListener('hide', (evnt) -> {
			fpsVar.x = 10;
			fpsVar.y = 3;
			FlxG.sound.soundTray.visible = false;
		});

		// onCrash('my balls itch');

	}

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real they don't get enough credit for their work
	#if CRASH_HANDLER
	function onCrash(e:Dynamic):Void
	{
		var message:String = "";
		if ((e is UncaughtErrorEvent))
			message = try Std.string(e.error) catch(_:haxe.Exception) "Unknown";
		else
			message = try Std.string(e) catch(_:haxe.Exception) "Unknown";
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "dghfghdgfhdghfgdhgfhdghfgdhg_" + dateNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		Sys.stderr().writeString('$errMsg\n');

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + '\nUncaught Error: $message\nplease DONT report this to the psych engine github\nthis mod\'s source is basically modified to hell and back');

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		var balls = Application.current.createWindow({
			width: 500,
			height: 400,
			resizable: false,
			title: 'kill yourself!!!!',
			context: {
				vsync: true,
				type: CAIRO,
				hardware: true,
			}
		});
		balls.stage.align = "tl";
		balls.stage.scaleMode = StageScaleMode.NO_SCALE;
		balls.focus();
		var golour:FlxColor = WindowblindNatives.getRealAccentColour();
		golour.alpha = 0x99;
		WindowblindNatives.enableBlur(golour);
		balls.stage.addChild(new WindowBorder(balls, 'shit yourself!!!!', true));

		balls.onClose.add(() -> Sys.exit(0));

		var crashHeader:TextField = new TextField();
		crashHeader.selectable = false;
		crashHeader.mouseEnabled = false;
		crashHeader.width = 500;
		crashHeader.x = 8;
		crashHeader.y = 8 + 35 + 2;
		crashHeader.text = 'whoops, looks like the game shit itself\nwell heres a crashlog';
		crashHeader.defaultTextFormat = new TextFormat(Paths.font('segoeui.ttf'), 24, 0xFFFFFF);
		balls.stage.addChild(crashHeader);


		var crashlog:TextField = new TextField();
		crashlog.selectable = false;
		crashlog.mouseEnabled = false;
		crashlog.width = 500;
		crashlog.x = 8;
		crashlog.y = crashHeader.y + crashHeader.height - 24;
		crashlog.height = 400 - 80 - crashlog.y;
		crashlog.text = '$message\n$errMsg';
		crashlog.defaultTextFormat = new TextFormat(Paths.font('segoeui.ttf'), 12, 0xFFFFFF);
		balls.stage.addChild(crashlog);

		var m:Array<String> = ['continue', 'restart game', 'close'];

		var pastButton:WindowblindButton = null;

		for (button in 0...m.length) {
			var thing:TextField = new TextField();
			thing.selectable = false;
			thing.mouseEnabled = false;
			thing.width = 500;
			thing.text = m[button];
			thing.defaultTextFormat = new TextFormat(Paths.font('segoeui.ttf'), 18, 0xFFFFFF);
			thing.width = thing.textWidth + 20;
			thing.height = 40;
			thing.defaultTextFormat.align = CENTER;
			var buttonnnnnnn:WindowblindButton = new WindowblindButton(thing, true);
			buttonnnnnnn.y = crashlog.y + crashlog.height + 12;
			thing.x += 2;
			thing.y += 2;
			if (pastButton != null) buttonnnnnnn.x = pastButton.x + pastButton.width;
			buttonnnnnnn.x += 8;
			balls.stage.addChild(buttonnnnnnn);
			pastButton = buttonnnnnnn;
		}


		FlxG.vcr.pause();
		FlxG.autoPause = false;
		stage.__rendering = true;
	}
	#end
}

@:publicFields
class WindowBlindsDragFlags {
	static inline final NONE:Int = 0;
	static inline final LEFT:Int = 1;
	static inline final TOP:Int = 2;
	static inline final RIGHT:Int = 4;
	static inline final BOTTOM:Int = 8;
	static inline final TOPLEFT:Int = TOP | LEFT;
	static inline final TOPRIGHT:Int = TOP | RIGHT;
	static inline final BOTTOMLEFT:Int = BOTTOM | LEFT;
	static inline final BOTTOMRIGHT:Int = BOTTOM | RIGHT;
}

// holy hell this code is hot garbage
// someone remind me to refactor this later
@:access(openfl.ui.MouseCursor) // IM COME YOU
@:access(lime.ui.Window)
class WindowBorder extends Sprite {
	private var borderShape:Shape;
	private var captionShape:Shape;
	private var captionContainer:Sprite;
	private var captionText:TextField;
	private var captionIcon:Bitmap;
	public var forcedVisible:Bool = true;

	private var lastClickTime:Float = 0;
	private var dragging:Bool = false;
	private var resizing:Bool = false;
	private var dragOffset:Array<Float> = [0, 0];
	private var resizeBools:Array<Bool> = [false, false];
	private var resizeAnchors:Array<Int> = [0, 0];
	private var resizeSize:Array<Int> = [0, 0];
	private var resizePos:Array<Int> = [0, 0];
	private var resizePosBalls:Array<Int> = [0, 0];

	public var resizeFlag:Int = WindowBlindsDragFlags.NONE;

	private var drawAlpha:Float = 0.2;

	private var hideTimer:Timer;
	private var captionButtons:Sprite;
	private var buttonArray:Array<Sprite> = [];

	private static final doubleClickTime:Int = WindowblindNatives.getDoubleClickTime();
	private static final frameColorPath:String = 'SOFTWARE\\Microsoft\\Windows\\DWM';
	private static final frameColorValue:String = 'AccentColor';

	public static var borderColor(default, null):Int = 0x99008c;

	private var targetWindow:lime.ui.Window;
	public function new(target:lime.ui.Window, ?borderTitle:String, ?solid:Bool = false) {
		targetWindow = target;
		targetWindow.borderless = true;
		super();
		borderShape = new Shape();

		captionContainer = new Sprite();
		captionContainer.x = captionContainer.y = 8;

		if (solid) drawAlpha = 1;

		WindowblindNatives.getRealAccentColour();
		try borderColor = WindowblindNatives.getRealAccentColour() catch(e)
			try borderColor = Std.int(WindowblindNatives.getAccentColour()) catch(estrogen)
				try borderColor = WindowblindNatives.getSystemColour(10) catch(estrogen) {}

		WindowblindNatives.hookShadow();
		WindowblindNatives.setShadow(true);

		captionContainer.addEventListener(MouseEvent.MOUSE_DOWN, (evnt) -> {
			if (evnt.stageX >= captionButtons.x + captionContainer.x) return; // OPENFL IS STUPID !!!!!
			dragging = true;
			dragOffset = [evnt.localX, evnt.localY];
		});

		captionContainer.addEventListener(MouseEvent.MOUSE_UP, (evnt) -> dragging = false);
		captionContainer.addEventListener(MouseEvent.CLICK, (evnt) -> {
			var curTime = Lib.getTimer();
			if ((curTime - lastClickTime) < doubleClickTime) {
				targetWindow.stage.window.maximized = !targetWindow.stage.window.maximized;
				lastClickTime = 0;
				return;
			} 
			lastClickTime = curTime;
		});

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
		captionText.x = 30;
		captionText.y = 2;
		captionText.selectable = false;
		captionText.mouseEnabled = false;
 
		addChild(borderShape);
		captionContainer.addChild(captionShape);
		captionContainer.addChild(captionIcon);
		captionContainer.addChild(captionText);

		addChild(captionContainer);
		captionContainer.addChild(captionButtons);

		captionButtons.scaleX = 1.2;
		captionButtons.scaleY = 1.2;
		var balls = ['close', 'maximize', 'minimize'];
		balls.reverse();
		for (bitmap in balls) {
			var bitmapBalls:Bitmap = new Bitmap(Paths.image('gameframe/$bitmap').bitmap, ALWAYS, false);
			var buttonSprite:WindowblindButton = new WindowblindButton(bitmapBalls, false, (bitmap == 'close' ? 0xFF0000 : 0xFFFFFF));

			buttonArray.push(buttonSprite);
			buttonSprite.x = 45 * balls.indexOf(bitmap);
			captionButtons.addChild(buttonSprite);

			buttonSprite.addEventListener(MouseEvent.MOUSE_UP, (evnt) -> {
				switch (bitmap) {
					case 'close': targetWindow.onClose.dispatch();
					case 'minimize': targetWindow.minimized = !targetWindow.minimized;
					case 'maximize': targetWindow.maximized = !targetWindow.maximized;
					default: throw 'whar ???';
				}
			});
		}

		redraw();

		targetWindow.onResize.add((x, y) -> redraw());
		targetWindow.onMaximize.add(() -> {
			cast(buttonArray[1].getChildAt(1), Bitmap).bitmapData = Paths.image('gameframe/unmaximize').bitmap;
			WindowblindNatives.setShadow(false);
		});

		targetWindow.onRestore.add(() -> {
			cast(buttonArray[1].getChildAt(1), Bitmap).bitmapData = Paths.image('gameframe/maximize').bitmap;
			WindowblindNatives.setShadow(true);
		});

		#if !debug
		targetWindow.onClose.add(() -> {
			targetWindow.onClose.cancel();
			FlxG.vcr.pause();
			FlxG.sound.pause();
			FlxG.autoPause = false;
			FlxG.sound.play(Paths.sound('table')).onComplete = () -> Sys.exit(0);
			Actuate.tween(targetWindow, 0.5, {y: targetWindow.display.bounds.height}).ease(Expo.easeIn);
		});
		#end

		timeout();

		// if (!target.resizable) return;

		targetWindow.stage.addEventListener(MouseEvent.MOUSE_MOVE, (evnt) -> {
			if (!resizing) {
				resizeFlag = WindowBlindsDragFlags.NONE;
				var targetCursor:MouseCursor = AUTO;
				if (evnt.stageX <= 4) resizeFlag |= Main.WindowBlindsDragFlags.LEFT;
				if (evnt.stageX >= targetWindow.width - 4) resizeFlag |= Main.WindowBlindsDragFlags.RIGHT;
				if (evnt.stageY <= 4) resizeFlag |= Main.WindowBlindsDragFlags.TOP;
				if (evnt.stageY >= targetWindow.height - 4) resizeFlag |= Main.WindowBlindsDragFlags.BOTTOM;
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
			timeout();
		});

		targetWindow.stage.addEventListener(MouseEvent.MOUSE_DOWN, (evnt) -> if (resizeFlag != 0) resizing = true);
		targetWindow.stage.addEventListener(MouseEvent.MOUSE_UP, (evnt) -> resizing = false);

		targetWindow.stage.addEventListener(Event.ENTER_FRAME, (evnt) -> {
			var xBalls = 0, yBalls = 0;
			WindowblindNatives.getMousePos(xBalls, yBalls);
			if (resizing) {
				switch (resizeFlag) {
					case WindowBlindsDragFlags.LEFT:
						var thing:Int = xBalls - (resizePos[0] - resizePosBalls[0]);
						targetWindow.x = thing;
						targetWindow.width = resizePosBalls[2] - thing;
					case WindowBlindsDragFlags.RIGHT:
						targetWindow.width = resizeSize[0] - resizePos[0] + xBalls;
					case WindowBlindsDragFlags.BOTTOM:
						targetWindow.height = resizeSize[1] - resizePos[1] + yBalls;
					case WindowBlindsDragFlags.TOP:
						var thing:Int = yBalls - (resizePos[1] - resizePosBalls[1]);
						targetWindow.y = thing;
						targetWindow.height = resizePosBalls[3] - thing;
					case WindowBlindsDragFlags.BOTTOMRIGHT:
						targetWindow.resize(resizeSize[0] - resizePos[0] + xBalls, resizeSize[1] - resizePos[1] + yBalls);
					case WindowBlindsDragFlags.BOTTOMLEFT:
						var thing:Int = xBalls - (resizePos[0] - resizePosBalls[0]);
						targetWindow.x = thing;
						targetWindow.resize(resizePosBalls[2] - thing, resizeSize[1] - resizePos[1] + yBalls);
					case WindowBlindsDragFlags.TOPLEFT:
						var thing:Int = xBalls - (resizePos[0] - resizeSize[0]);
						var thingballs:Int = yBalls - (resizePos[1] - resizeSize[1]);
						targetWindow.move(thing, thingballs);
						targetWindow.resize(resizePosBalls[2] - thing, resizePosBalls[3] - thingballs);
					default:
				}
			}
			if (dragging) targetWindow.move(xBalls - Std.int(dragOffset[0]) - 8, yBalls - Std.int(dragOffset[1]) - 8);
		});
	}

	public function timeout() {
		if (forcedVisible) {
			FlxG.mouse.visible = visible = true;
			dispatchEvent(new Event('show'));
			hideTimer?.stop();
			hideTimer = Timer.delay(() -> {
				FlxG.mouse.visible = visible = false;
				dispatchEvent(new Event('hide'));
			}, 1500);
			return;
		}
		FlxG.mouse.visible = visible = false;
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

class WindowblindButton extends Sprite {
	public function new(label:DisplayObject, hasBg:Bool = false, hightlightColor:Int = 0xFFFFFF) {
		super();
		if (hasBg) {
			graphics.beginFill(WindowBorder.borderColor, 1);
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

		addEventListener(MouseEvent.MOUSE_DOWN, (evnt) -> targetAlpha = fade = 0.7);
		addEventListener(MouseEvent.MOUSE_OVER, (evnt) -> targetAlpha = 1);
		addEventListener(MouseEvent.MOUSE_OUT, (evnt) -> targetAlpha = 0);

		var anusTime:Float = 0; 
		addEventListener(Event.ENTER_FRAME, (evnt) -> {
			var curTime = Sys.time();
			var elapsed = curTime - anusTime;
			if (targetAlpha > 0) fade = Math.min(fade + elapsed / 0.2, targetAlpha)
			else fade = Math.max(fade - elapsed / 0.2, 0);

			highlight.alpha = fade * 0.3;
			anusTime = curTime;
		});
	}
}

@:hlNative('windowblinds')
class WindowblindNatives {
	public static function getMousePos(x:hl.Ref<Int>, y:hl.Ref<Int>):Void {}
	public static function getDoubleClickTime():Int return 0;
	public static function getSystemColour(index:Int):Int return 0;
	public static function getAccentColour():hl.F64 return 0;

	public static function hookShadow():Void {}
	public static function setShadow(enabled:Bool):Void {}
	public static function getShadow():Bool return false;
	public static function enableBlur(coluor:Int):Void {};
	public static function getRealAccentColour():Int return 0;
}