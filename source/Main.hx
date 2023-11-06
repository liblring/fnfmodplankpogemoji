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
import lime.app.Application;
import flash.display.Shape;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;
import openfl.ui.MouseCursor;
import openfl.ui.Mouse;

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
		#if (CRASH_HANDLER && !hl)
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end
		
		#if (CRASH_HANDLER && hl)
		hl.Api.setErrorHandler(onCrash);
		#end

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}
	
		PlankPrefs.loadDefaultKeys();
		addChild(new FlxGame(game.width, game.height, game.initialState, game.framerate, game.framerate, game.skipSplash, game.startFullscreen));
		FlxG.sound.soundTray.parent.removeChild(FlxG.sound.soundTray);
		addChild(FlxG.sound.soundTray); // terrible fix but eh fuck it

		FlxG.mouse.useSystemCursor = true;

		PlayerSettings.init();
		FlxG.save.bind('funkin', CoolUtil.getSavePath());
		PlankPrefs.loadPrefs();
		Highscore.load();

		addChild(fpsVar = new FPS(10, 3));
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
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

		addChild(border = new WindowBorder(FlxG.stage.window));
		// border.alpha = 0.5;
		border.addEventListener('show', (evnt) -> {
			fpsVar.x = 8;
			fpsVar.y = 8 + 35 + 2;
		});
		border.addEventListener('hide', (evnt) -> {
			fpsVar.x = 10;
			fpsVar.y = 3;
		});
	}

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real they don't get enough credit for their work
	#if CRASH_HANDLER
	function onCrash(e:Dynamic):Void
	{
		var message:String = "";
		if ((e is UncaughtErrorEvent))
			message = e.error;
		else
			message = try Std.string(e) catch(_:haxe.Exception) "Unknown";
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "PsychEngine_" + dateNow + ".txt";

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

		trace(errMsg);

		errMsg += "\nUncaught Error: " + message + "\nPlease report this error to the GitHub page: https://github.com/ShadowMario/FNF-PsychEngine\n\n> Crash Handler written by: sqirra-rng";

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		#if hl
		var flags:haxe.EnumFlags<hl.UI.DialogFlags> = new haxe.EnumFlags<hl.UI.DialogFlags>();
		flags.set(hl.UI.DialogFlags.IsError);
		hl.UI.dialog("Error!", errMsg, flags);
		#else
		Application.current.window.alert(errMsg, "Error!");
		#end

		#if discord_rpc
		DiscordClient.shutdown();
		#end
		Sys.exit(1);
	}
	#end
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

	private var hideTimer:Timer;
	private var captionButtons:Sprite;
	private var buttonArray:Array<Sprite> = [];

	private static final doubleClickTime:Int = GameframeNatives.getDoubleClickTime();

	@:allow(flixel.system.ui.FlxSoundTray)
	private static var borderColor(default, null):Int = 0x99008c;

	private var targetWindow:lime.ui.Window;
	public function new(target:lime.ui.Window) {
		targetWindow = target;
		targetWindow.borderless = true;
		super();
		borderShape = new Shape();

		captionContainer = new Sprite();
		captionContainer.x = captionContainer.y = 8;

		captionContainer.addEventListener(MouseEvent.MOUSE_DOWN, (evnt) -> {
			if (evnt.stageX >= captionButtons.x + captionContainer.x) return; // OPENFL IS STUPID !!!!!
			dragging = true;
			dragOffset = [evnt.localX, evnt.localY];
		});

		captionContainer.addEventListener(MouseEvent.MOUSE_UP, (evnt) -> dragging = false);
		captionContainer.addEventListener(MouseEvent.CLICK, (evnt) -> {
			var curTime = Lib.getTimer();
			if ((curTime - lastClickTime) < doubleClickTime) {
				FlxG.stage.window.maximized = !FlxG.stage.window.maximized;
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
		captionText.text = 'mnalk opd yow!!!! yow that sure is a mod';
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
			var buttonSprite:Sprite = new Sprite();
			var bg:Shape = new Shape();
			var bitmapBalls:Bitmap = new Bitmap(Paths.image('gameframe/$bitmap').bitmap, ALWAYS, false);
			bg.graphics.beginFill((bitmap == 'close' ? 0xFF0000 : 0xFFFFFF), 1);
			bg.graphics.drawRoundRect(0, 0, bitmapBalls.width, bitmapBalls.height, 5);

			buttonArray.push(buttonSprite);
			buttonSprite.addChild(bg);
			buttonSprite.addChild(bitmapBalls);
			buttonSprite.x = 45 * balls.indexOf(bitmap);
			captionButtons.addChild(buttonSprite);
			buttonSprite.addEventListener(MouseEvent.MOUSE_UP, (evnt) -> {
				switch (bitmap) {
					case 'close': Sys.exit(0);
					case 'minimize': targetWindow.minimized = !targetWindow.minimized;
					case 'maximize': targetWindow.maximized = !targetWindow.maximized;
					default: throw 'whar ???';
				}
			});

			var targetAlpha:Float = 0;
			var fade:Float = 0;
			buttonSprite.addEventListener(MouseEvent.MOUSE_DOWN, (evnt) -> targetAlpha = fade = 0.7);
			buttonSprite.addEventListener(MouseEvent.MOUSE_OVER, (evnt) -> targetAlpha = 1);
			buttonSprite.addEventListener(MouseEvent.MOUSE_OUT, (evnt) -> targetAlpha = 0);
			buttonSprite.addEventListener(Event.ENTER_FRAME, (evnt) -> {
				if (targetAlpha > 0) fade = Math.min(fade + FlxG.elapsed / 0.2, targetAlpha)
				else fade = Math.max(fade - FlxG.elapsed / 0.2, 0);

				bg.alpha = fade * 0.3;
			});
		}


		redraw();

		FlxG.stage.addEventListener(MouseEvent.MOUSE_MOVE, (evnt) -> {
			if (!resizing) {
				var targetCursor:MouseCursor = AUTO;
				var bottomLeft:Bool = evnt.stageX <= 4 && evnt.stageY >= targetWindow.height - 8;
				var topRight:Bool = evnt.stageX >= targetWindow.width - 8 && evnt.stageY <= 4;
				var topLeft:Bool = evnt.stageX <= 4 && evnt.stageY <= 4;
				var bottomRight:Bool = evnt.stageX >= targetWindow.width - 8 && evnt.stageY >= targetWindow.height - 8;
				if (bottomLeft || topRight) targetCursor = __RESIZE_NESW;
				if (topLeft || bottomRight) targetCursor = __RESIZE_NWSE;
				if (!(evnt.stageX <= 4 || evnt.stageX >= targetWindow.width - 8) && (evnt.stageY <= 4 || evnt.stageY >= targetWindow.height - 8)) targetCursor = __RESIZE_NS;
				if ((evnt.stageX <= 4 || evnt.stageX >= targetWindow.width - 8) && !(evnt.stageY <= 4 || evnt.stageY >= targetWindow.height - 8)) targetCursor = __RESIZE_WE;
				switch (Mouse.cursor) {
					case __RESIZE_WE: resizeBools = [true, false];
					case __RESIZE_NS: resizeBools = [false, true];
					case __RESIZE_NWSE | __RESIZE_NESW: resizeBools = [true, true];
					default:
				}
				if (topLeft) resizeAnchors = [1, 1];
				if (topRight) resizeAnchors = [0, 1];
				if (bottomLeft) resizeAnchors = [1, 0];
				if (bottomRight) resizeAnchors = [0, 0];
				resizeSize = [targetWindow.width, targetWindow.height];
				resizePos = [targetWindow.x, targetWindow.y];
				Mouse.cursor = targetCursor;
			}
			timeout();
		});

		FlxG.stage.addEventListener(MouseEvent.MOUSE_DOWN, (evnt) -> if (Mouse.cursor != AUTO) resizing = true);
		FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, (evnt) -> if (Mouse.cursor != AUTO) resizing = false);
		FlxG.stage.addEventListener(Event.ENTER_FRAME, (evnt) -> {
			if (dragging || resizing) targetWindow.onRender.cancel(); // prevent lime from shitting itself when moving the window
			var xBalls = 0, yBalls = 0;
			GameframeNatives.getMousePos(xBalls, yBalls);
			if (resizing) {
				if (resizeBools[0]) targetWindow.width = (xBalls - targetWindow.x + (resizeSize[0] * resizeAnchors[0]));
				if (resizeBools[1]) targetWindow.height = (yBalls - targetWindow.y + (resizeSize[1] * resizeAnchors[1]));
				if (resizeAnchors[0] == 1) targetWindow.x = resizePos[0] + resizeSize[0] - targetWindow.width;
				if (resizeAnchors[1] == 1) targetWindow.y = resizePos[1] + resizeSize[1] - targetWindow.height;
			}
			if (dragging) targetWindow.move(xBalls - Std.int(dragOffset[0]) - 8, yBalls - Std.int(dragOffset[1]) - 8);
		});
		targetWindow.onResize.add((x, y) -> redraw());
		targetWindow.onMaximize.add(() -> cast(buttonArray[1].getChildAt(1), Bitmap).bitmapData = Paths.image('gameframe/unmaximize').bitmap);
		targetWindow.onRestore.add(() -> cast(buttonArray[1].getChildAt(1), Bitmap).bitmapData = Paths.image('gameframe/maximize').bitmap);
		timeout();
	}

	private function timeout() {
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

		borderShape.graphics.lineStyle(2, borderColor, 0.3, true, NONE, SQUARE, MITER, 1.414);
		borderShape.graphics.drawRect(4, 4, targetWindow.width - 8, targetWindow.height - 8);

		captionShape.graphics.beginFill(borderColor, 0.2);
		captionShape.graphics.drawRoundRect(0, 0, targetWindow.width - 16, 35, 5);
		captionText.width = targetWindow.width - 16 - 30 - captionButtons.width;
		captionButtons.x = targetWindow.width - 16 - captionButtons.width;
	}


	private static function getRegistryKey(path:String, value:String):String { 
		var rorcers:Process = new Process('reg', ['query', path, '/v', value]);
		if(rorcers.exitCode() != 0) {
			var error:String = rorcers.stderr.readAll().toString();
			rorcers.close();
			throw 'thats such a retro error,.,.,., $error';
		}

		var response = rorcers.stdout.readAll().toString();
		rorcers.close();
		var lines = response.split('\n');
		for(line in lines) {
			line = line.trim();
			if(line.substr(0, 'path'.length).toLowerCase() == 'path') {
				var column = 0;
				var wasSpace = false;
				for(pos in 0...line.length) {
					var isSpace = line.isSpace(pos);
					if(wasSpace && !isSpace) {
						column++;
						if(column == 2) {
							return line.substr(pos);
						}
					}
					wasSpace = isSpace;
				}
			}
		}
		throw 'wtfs that return is weird,.,.,.,., $response';
	}

	private static function __init__() {
		try borderColor = GameframeNatives.getRealAccentColour() catch(e)
			try borderColor = Std.int(GameframeNatives.getAccentColour()) catch(estrogen)
				try borderColor = GameframeNatives.getSystemColour(10) catch(estrogen) {}
	}
}

@:hlNative('gameframe')
class GameframeNatives {
	public static function getMousePos(x:hl.Ref<Int>, y:hl.Ref<Int>):Void {}
	public static function getDoubleClickTime():Int return 0;
	public static function getSystemColour(index:Int):Int return 0;
	public static function getAccentColour():hl.F64 return 0;
	public static function getRealAccentColour():Int return 0;

	public static function hookShadow():Void {}
	public static function setShadow(enabled:Bool):Void {}
	public static function getShadow():Bool return false;
}