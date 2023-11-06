package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import haxe.Timer;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.filters.DropShadowFilter;
import motion.Actuate;

using StringTools;

class Achievements {
	public static var achievementsStuff:Array<Dynamic> = [ //Name, Description, Achievement save tag, Hidden achievement
		["rude",						"how are yuou this rude smh,",						'rude',					false],
		["the fuck are you doing",		"set your fps cap higher than your refresh rate",	'fps',					false],
		["overpetted",					"what have you done",								'overpet',				false],
		["help with my flower",			"try to run a lua script",					'helpwithmyflower',				false],
	];

	public static var achievementsMap:Map<String, Bool> = new Map<String, Bool>();

	public static var henchmenDeath:Int = 0;
	public static function unlockAchievement(name:String, ?onComplete:Void->Void):Void {
		if (isAchievementUnlocked(name)) { if (onComplete != null) onComplete(); return;} // doesent really make sence but shut up
		FlxG.log.add('Completed achievement "' + name +'"');
		achievementsMap.set(name, true);
		var thingamabob:AchievementThing = new AchievementThing(name);
		var sound = Paths.sound('trophy');
		PlankPrefs.saveSettings();

		Paths.dumpExclusions.push('assets/images/achievements/$name.png'); // bullshit code but whatever, exclude the achievement image from clearing
		Timer.delay(() -> {
			FlxG.sound.play(sound, 0.7);
			thingamabob.alpha = 0;
			Actuate.tween(thingamabob, 0.25, {alpha: 1});
			FlxG.stage.addChild(thingamabob);
			Actuate.tween(thingamabob, 0.25, {alpha: 0}, false).onComplete(() -> {
				Paths.dumpExclusions.remove('assets/images/achievements/$name.png');
				FlxG.stage.removeChild(thingamabob);
				if (onComplete != null) onComplete();
			}).delay(6);
		}, 1000);
	}

	public static function isAchievementUnlocked(name:String) 
		return achievementsMap.exists(name) && achievementsMap.get(name);

	public static function getAchievementIndex(name:String) {
		for (i in 0...achievementsStuff.length) {
			if(achievementsStuff[i][2] == name) {
				return i;
			}
		}
		return -1;
	}

	public static function loadAchievements():Void {
		if(FlxG.save.data != null) {
			if(FlxG.save.data.achievementsMap != null) {
				achievementsMap = FlxG.save.data.achievementsMap;
			}
			if(henchmenDeath == 0 && FlxG.save.data.henchmenDeath != null) {
				henchmenDeath = FlxG.save.data.henchmenDeath;
			}
		}
	}

}

class AttachedAchievement extends FlxSprite {
	public var sprTracker:FlxSprite;
	private var tag:String;
	public function new(x:Float = 0, y:Float = 0, name:String) {
		super(x, y);

		changeAchievement(name);
		antialiasing = PlankPrefs.data.globalAntialiasing;
	}

	public function changeAchievement(tag:String) {
		this.tag = tag;
		reloadAchievementImage();
	}

	public function reloadAchievementImage() {
		if(Achievements.isAchievementUnlocked(tag)) {
			loadGraphic(Paths.image('achievements/' + tag));
		} else {
			loadGraphic(Paths.image('achievements/lockedachievement'));
		}
		scale.set(0.7, 0.7);
		updateHitbox();
	}

	override function update(elapsed:Float) {
		if (sprTracker != null)
			setPosition(sprTracker.x - 130, sprTracker.y + 25);

		super.update(elapsed);
	}
}

class AchievementThing extends Sprite {
	var achievementImage:Bitmap;
	var descriptionText:TextField;
	var achievementText:TextField;

	public function new(achievement:String = 'rude') {
		super();
		x = y = 10;
		var balls:Array<Dynamic> = Achievements.achievementsStuff[Achievements.getAchievementIndex(achievement)];
		achievementImage = new Bitmap(Paths.image('achievements/$achievement').bitmap);
		achievementImage.y = achievementImage.x = 5;
		achievementImage.scaleX = 0.5;
		achievementImage.scaleY = 0.5;
		addChild(achievementImage);

		graphics.lineStyle(2, 0x454346, 0.5);
		graphics.beginFill(0x454346, 0.75);
		graphics.drawRoundRect(0, 0, 400, achievementImage.height + 10, 12);
		graphics.endFill();

		var defaultTextFormat:TextFormat = new TextFormat(Paths.font('rodin.otf'), 18, 0xFFFFFF); 
		var defaultTextFormatDescription:TextFormat = new TextFormat(Paths.font('rodin.otf'), 16, 0xFFFFFF); 

		// todo: get some kind of alternative for DropShadowFilter because it breaks on textfields
		// reported the bug at https://github.com/openfl/openfl/issues/2673
		var dropshadow:DropShadowFilter = new DropShadowFilter();
		dropshadow.quality = 3;
		dropshadow.distance = 8;
		dropshadow.blurX = dropshadow.blurY = 8;
		dropshadow.angle = 45;
		dropshadow.strength = 1;

		achievementText = new TextField();
		descriptionText = new TextField();

		achievementText.mouseEnabled = descriptionText.mouseEnabled = false;
		achievementText.selectable = descriptionText.selectable = false;

		achievementText.filters = descriptionText.filters = [dropshadow];
		achievementText.defaultTextFormat = defaultTextFormat;
		descriptionText.defaultTextFormat = defaultTextFormatDescription;

		achievementText.width = descriptionText.width = width;

		achievementText.x = descriptionText.x =  achievementImage.x + achievementImage.width + 5;
		achievementText.y = 10;
		achievementText.text = 'You have earned an acquirent.';

		descriptionText.y = 42;
		descriptionText.text = balls[1];
		addChild(achievementText);
		addChild(descriptionText);
	}
}