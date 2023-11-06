package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;
import openfl.filters.ShaderFilter;

@:access(flixel.FlxGame._filters)
class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:MenuList;

	public static final gaySexScale:Float = 2.88;

	var menuItems:Array<String> = ['resume', 'restart', 'exit'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	static var killballs:HalftoneShader = new HalftoneShader();
	static var ass:ShaderFilter = new ShaderFilter(killballs);

	public static var songName:String = '';

	public function new(x:Float, y:Float)
	{
		killballs.scale.value = [10];
		if (FlxG.game._filters == null) FlxG.game._filters = [];
		FlxG.game._filters.push(ass);
		super();

		pauseMusic = new FlxSound();
		if(songName != null)
			pauseMusic.loadEmbedded(Paths.music(songName), true, true);
		else if (songName != 'None')
			pauseMusic.loadEmbedded(Paths.music(Paths.formatToSongPath(PlankPrefs.data.pauseMusic)), true, true);

		pauseMusic.volume = 0.5;
		pauseMusic.play();

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		FlxTween.tween(bg, {alpha: 0.6}, 0.6, {ease: FlxEase.expoOut});
		bg.alpha = 1;
		bg.scrollFactor.set();
		add(bg);

		var thingamabob:FlxSprite = new FlxSprite(0, 0, Paths.image('pause/selector'));
		thingamabob.scrollFactor.set();
		thingamabob.scale.scale(gaySexScale);
		thingamabob.updateHitbox();
		thingamabob.screenCenter(Y);
		thingamabob.x -= FlxG.width;
		FlxTween.tween(thingamabob, {x: 0}, 0.6, {ease: FlxEase.expoOut});
		add(thingamabob);

		grpMenuShit = new MenuList(0, 0, VERTICAL(true));
		grpMenuShit.moveWithCurSelection = true;
		grpMenuShit.focused = true;
		add(grpMenuShit);

		grpMenuShit.onSelect.add((sel) -> {
			if (!(cantUnpause <= 0 || !PlankPrefs.data.controllerMode)) return;
			switch (menuItems[sel])
			{
				case "resume":
					close();
				case "restart":
					restartSong();
				case "exit":
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;

					WeekData.loadTheFirstEnabledMod();
					MusicBeatState.switchState(new PaidplayState());
					PlayState.cancelMusicFadeTween();

					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		});

		for (i in 0...menuItems.length) {
			var item = generateFunkyText();
			item.animation.play(menuItems[i]);
			grpMenuShit.add(item);
		}
		grpMenuShit.x = 180;
		grpMenuShit.y = 320;
		grpMenuShit.padding = 50;
		grpMenuShit.moveDirection.x = 0.15;
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		var things:Array<String> = ['topleft', 'topright', 'bottomleft', 'bottomright'];
		var thingAnchors:Array<Array<Float>> = [[0, 0], [1, 0], [0, 1], [1, 1]];
		for (thing in 0...things.length) {
			var thingsprite:FlxSprite = new FlxSprite(0, 0, Paths.image('pause/${things[thing]}thing'));
			thingsprite.scrollFactor.set();
			thingsprite.scale.scale(gaySexScale);
			thingsprite.updateHitbox();

			thingsprite.x = FlxG.width * thingAnchors[thing][0] - thingsprite.width * thingAnchors[thing][0];
			add(thingsprite);
			var gay:Float = FlxG.height * thingAnchors[thing][1] - thingsprite.height * thingAnchors[thing][1];
			thingsprite.y = gay;
			thingsprite.y += (thing <= 1 ? -FlxG.height : FlxG.height);
			FlxTween.tween(thingsprite, {y: gay}, 0.6, {ease: FlxEase.expoOut, startDelay: thing / 10});
		}
	}

	function generateFunkyText() {
		var kill:FlxSprite = new FlxSprite(0, 0);
		kill.loadGraphic(Paths.image('pause/options'), true, 0, 40);
		kill.animation.add('restart', [0], 0);
		kill.animation.add('resume', [1], 0);
		kill.animation.add('exit', [2], 0);
		kill.scrollFactor.set();

		kill.scale.scale(gaySexScale);
		kill.updateHitbox();
		return kill;
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float) {
		cantUnpause -= elapsed;
		super.update(elapsed);
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans) {
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
			MusicBeatState.resetState();
	}

	override function destroy()
	{
		FlxG.game._filters.remove(ass);
		pauseMusic.destroy();

		super.destroy();
	}
}
