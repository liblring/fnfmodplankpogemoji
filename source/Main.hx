package;

import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
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
import windowblinds.Windowblinds;
import windowblinds.WindowblindNatives;
import windowblinds.WindowblindButton;
import windowblinds.WindowblindDragFlags;

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
	public static var border:Windowblinds;
	var crashAlreadyHappening:Bool = false;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void {
		hl.UI.closeConsole();
		Lib.current.addChild(new Main());
	}

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

		FlxG.game.addEventListener(MouseEvent.MOUSE_DOWN, (evnt) -> if (border.resizeFlag != WindowblindDragFlags.NONE) evnt.stopImmediatePropagation());
		FlxG.game.addEventListener(MouseEvent.MOUSE_UP, (evnt) -> if (border.resizeFlag != WindowblindDragFlags.NONE) evnt.stopImmediatePropagation());
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

		FlxG.stage.window.resizable = true; // ffs lime why isnt this enabled even though i enabled it in project.xml
		FlxG.stage.addChild(border = new Windowblinds(FlxG.stage.window));
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

		#if !debug
		FlxG.stage.window.onClose.add(() -> {
			FlxG.stage.window.onClose.cancel();
			FlxG.vcr.pause();
			FlxG.sound.pause();
			FlxG.autoPause = false;
			FlxG.sound.play(Paths.sound('table')).onComplete = () -> Sys.exit(0);
			Actuate.tween(FlxG.stage.window, 0.5, {y: FlxG.stage.window.display.bounds.height}).ease(Expo.easeIn);
		});
		#end
	}

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real they don't get enough credit for their work
	#if CRASH_HANDLER
	function onCrash(e:Dynamic):Void
	{
		if (crashAlreadyHappening) return;
		crashAlreadyHappening = true;
		var message:String = "";
		if ((e is UncaughtErrorEvent))
			message = try Std.string(e.error) catch(_:haxe.Exception) "Unknown";
		else
			message = try Std.string(e) catch(_:haxe.Exception) "Unknown";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();
		
		var errMsg:String = "";

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = './crash/dghfghdgfhdghfgdhgfhdghfgdhg_$dateNow.txt';

		for (stackItem in callStack)
			switch (stackItem) {
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}


		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + '\nUncaught Error: $message\nplease DONT report this to the psych engine github\nthis mod\'s source is basically modified to hell and back');

		Sys.stderr().writeString('$message\n\n$errMsg\n');
		Sys.stderr().writeString('Crash dump saved in ${Path.normalize(path)}\n');

		var balls = Application.current.createWindow({
			width: 500,
			height: 372,
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
		var die = new Windowblinds(balls, 'shit yourself!!!!', false, false);
		balls.stage.addChild(die);
		die.doTimeout = false;

		WindowblindNatives.enableAcrylic(die.windowPtr, golour);

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

		var m:Array<String> = [/*'continue',*/ 'restart game', 'close'];
		var killme:Array<Void->Void> = [/*() -> return,*/ FlxG.resetGame, () -> Sys.exit(0)];

		var pastButton:WindowblindButton = null;

		function renderHook(ctx):Void stage.window.onRender.cancel();

		for (button in 0...m.length) {
			var thing:TextField = new TextField();
			thing.selectable = false;
			thing.mouseEnabled = false;
			thing.width = 500;
			thing.text = m[button];
			thing.defaultTextFormat = new TextFormat(Paths.font('segoeui.ttf'), 18, 0xFFFFFF);
			thing.width = thing.textWidth + 20;
			thing.height = 35;
			thing.defaultTextFormat.align = CENTER;
			var buttonnnnnnn:WindowblindButton = new WindowblindButton(thing, true);
			buttonnnnnnn.y = crashlog.y + crashlog.height + 8;
			thing.x += 5;
			thing.y += 2;
			if (pastButton != null) buttonnnnnnn.x = pastButton.x + pastButton.width;
			buttonnnnnnn.x += 8;
			balls.stage.addChild(buttonnnnnnn);
			pastButton = buttonnnnnnn;
			buttonnnnnnn.onUp = () -> {
				stage.window.onRender.remove(renderHook);
				balls.close();
				crashAlreadyHappening = false;
				killme[button]();
				@:privateAccess stage.__rendering = false;
			}
		}

		stage.window.onRender.add(renderHook);
	}
	#end
} 