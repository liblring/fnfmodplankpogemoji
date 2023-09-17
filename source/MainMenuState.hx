package;

import flixel.addons.display.FlxBackdrop;
#if discord_rpc
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '3'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	var optionShit:Array<MainMenuButton> = [
		{x: 400,  y: 70,   scale: 2.7,  name:    'freeplay'},
		{x: 750,  y: 270,  scale: 4,    name: 	 'credits'},
		{x: 550,  y: 370,  scale: 4,    name: 	 'acquirents'},
		{x: 210,  y: 550,  scale: 3,    name:    'options'},
	];

	var magenta:FlxSprite;
	var gifcat:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	private final levicummingsgaylord:Array<String> = [
		'sillycatgooberwhat',
		'you-can-download-the-new-mnalk-opd-yow-v3-build-right-now!',
		'insertamenbreakorselectamenbreak',
		'SHUTTHEFUCL',
		'hiiiplaaank',
		'himatpat'
	  ];

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("he is mainmenustating", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var bigmenushit:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('bigmenubullshit'));
		bigmenushit.screenCenter();
		bigmenushit.antialiasing = ClientPrefs.globalAntialiasing;
		add(bigmenushit);

		var eventThingy:FlxBackdrop = new FlxBackdrop(Paths.image('sidewaysthingyidk'), Y);
		eventThingy.velocity.set(0, 55);
		eventThingy.x = 0;
		eventThingy.scale.set(1.2, 1.2);
		eventThingy.antialiasing = ClientPrefs.globalAntialiasing;
		add(eventThingy);

		var eventThingy2:FlxBackdrop = new FlxBackdrop(Paths.image('sidewaysthingyidk'), Y);
		eventThingy2.velocity.set(0, -55);
		eventThingy2.x = 1180;
		eventThingy2.scale.set(1.2, 1.2);
		eventThingy2.flipX = true;
		eventThingy2.updateHitbox();
		eventThingy2.antialiasing = ClientPrefs.globalAntialiasing;
		add(eventThingy2);

		gifcat = new FlxSprite(100, 50);
		gifcat.frames = Paths.getSparrowAtlas('catbounce');
		gifcat.animation.addByPrefix('bouncer', "cat bounce", 24);
		gifcat.animation.play("bouncer", 24);
		gifcat.antialiasing = ClientPrefs.globalAntialiasing;
		add(gifcat);

		var siller:FlxSprite = new FlxSprite(20, 0, Paths.image('sillymenuimages/${levicummingsgaylord[FlxG.random.int(0, levicummingsgaylord.length)]}'));
		siller.y = FlxG.height - siller.height - 20;
		add(siller);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length) {
			var option:MainMenuButton = optionShit[i];
			var menuItem:FlxSprite = new FlxSprite(option.x, option.y);
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + option.name);
			menuItem.animation.addByPrefix('idle', option.name + " basic", 24);
			menuItem.animation.addByPrefix('selected', option.name + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.setGraphicSize(Std.int(menuItem.height * option.scale));
			menuItem.updateHitbox();
			menuItems.add(menuItem);
		}

		//FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, 0, FlxG.width, "HOLY SHIT ITS THE FABLED MOD CALLED MNALK OPD YOW V" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("peppino.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		// Achievements.loadAchievements();
		// var leDate = Date.now();
		// if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
		// 	var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
		// 	if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
		// 		Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
		// 		giveAchievement();
		// 		ClientPrefs.saveSettings();
		// 	}
		// }
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky Freaky" achievement
	// function giveAchievement() {
	// 	// add(new AchievementObject('friday_night_play', camAchievement));
	// 	// FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
	// 	// trace('Giving achievement "friday_night_play"');
	// }
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.8) {
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin) {
			if (controls.UI_UP_P) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK) {
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT) {
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				// if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite) {
					if (curSelected != spr.ID) {
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween) {
								spr.kill();
							}
						});
					}
					else {
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker) {
							var daChoice:String = optionShit[curSelected].name;

							switch (daChoice) {
								case 'freeplay':
									MusicBeatState.switchState(new FreeplayState());
								case 'credits':
									MusicBeatState.switchState(new CreditsState());
								case 'acquirentsnts':
									MusicBeatState.switchState(new AchievementsMenuState());
								case 'options':
									LoadingState.loadAndSwitchState(new options.OptionsState());
							}
						});
					}
				});	
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys)) {
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
			{
				spr.x = FlxMath.lerp(spr.x, ((spr.ID == curSelected) ? FlxG.width * 0.5 : FlxG.width * 0.6), 0.15);
			});
	}

	function changeItem(huh:Int = 0) {
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite) {
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected) {
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}

typedef MainMenuButton = {
	var x:Int;
	var y:Int;
	var scale:Float;
	var name:String;
}