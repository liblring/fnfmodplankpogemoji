package;

import flixel.addons.display.FlxBackdrop;
#if desktop
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
//import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;

using StringTools;
typedef TitleData = {
	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Float
}

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	var titleJSON:TitleData;
	var logo:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var swagShader:ColorSwap;

	var transitioning:Bool = false;
	
	var petAmmount:Int = 0;
	var petThreshold:Int = 15;

	override public function create():Void { // todo: add big balls
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];


		// DEBUG BULLSHIT

		swagShader = new ColorSwap();

		super.create();

		// IGNORE THIS!!!
		titleJSON = Json.parse(Paths.getTextFromFile('images/gfDanceTitle.json'));

		if (FlxG.save.data.weekCompleted != null)
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;


		if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			FlxG.fullscreen = FlxG.save.data.fullscreen;

		persistentUpdate = true;
		persistentDraw = true;

		if(FlxG.sound.music == null) FlxG.sound.playMusic(Paths.music('freakyMenu'));

		Conductor.changeBPM(titleJSON.bpm);

		var bg:FlxBackdrop = new FlxBackdrop(Paths.image("mnalk"), XY, 0, 0);
		bg.velocity.set(100, 0);
		add(bg);

		swagShader = new ColorSwap();
		gfDance = new FlxSprite(titleJSON.gfx, titleJSON.gfy);

		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = PlankPrefs.data.globalAntialiasing;
		gfDance.scale.set(0.9, 0.9);
		gfDance.angle = 330;

		var bigtitleshit:FlxSprite = new FlxSprite(0, 0, Paths.image('titlescreenshite'));
		bigtitleshit.antialiasing = PlankPrefs.data.globalAntialiasing;
		
		logo = new FlxSprite(titleJSON.titlex, titleJSON.titley);
		logo.frames = Paths.getSparrowAtlas('logoBumpin');
		logo.antialiasing = PlankPrefs.data.globalAntialiasing;
		logo.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logo.animation.play('bump');
		logo.updateHitbox();

		add(gfDance);
		add(bigtitleshit);
		add(logo);

		titleText = new FlxSprite(titleJSON.startx, titleJSON.starty);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		
		titleText.animation.addByPrefix('idle', 'ENTER IDLE', 24);
		titleText.antialiasing = PlankPrefs.data.globalAntialiasing;
		titleText.animation.play('idle');
		add(titleText);

		gfDance.shader = swagShader.shader;
		logo.shader = swagShader.shader;
		titleText.shader = swagShader.shader;
	}

	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.mouse.overlaps(gfDance) && FlxG.mouse.justPressed && petAmmount < petThreshold) {
			petAmmount++;

			if (petAmmount >= petThreshold) {
				remove(gfDance);
				add(gfDance);
				FlxG.sound.play(Paths.sound('jumpscare'));
				FlxTween.tween(gfDance.scale, {x: 10, y: 10}, 0.5, {onComplete: (twn) -> {
					FlxG.game.visible = Main.fpsVar.visible = Main.border.forcedVisible = false;
					FlxG.sound.music.stop();
					Achievements.unlockAchievement('overpet', () -> Sys.exit(1), true);
				}});
			} else {
				FlxG.sound.play(Paths.sound('pet${FlxG.random.int(1, 6)}'));
				gfDance.scale.set(1.1, 0.5);
			}
		}

		if (petAmmount < petThreshold) gfDance.scale.set(FlxMath.lerp(gfDance.scale.x, 0.9, 0.16), FlxMath.lerp(gfDance.scale.y, 0.9, 0.16));

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		if(pressedEnter && !transitioning)
		{
			FlxG.camera.flash(PlankPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;

			new FlxTimer().start(1, function(tmr:FlxTimer) {
				MusicBeatState.switchState(new MainMenuState());
			});
		}

		if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
		if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;

		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();

		if(logo != null)
			logo.animation.play('bump', true);

		if(gfDance != null) {
			danceLeft = !danceLeft;
			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');
		}
	}
}
