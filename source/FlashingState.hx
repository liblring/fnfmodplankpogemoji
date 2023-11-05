package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;
	var myballs:Float = 0;

	var warnText:FlxText;
	var goober:FlxSprite;
	override function create()
	{
		persistentUpdate = true;
		persistentDraw = true;
		
		super.create();

		Paths.image('thumbsup');
		Paths.image('stop');
		Paths.image('disagree');

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width, "hey ffucker this mod contains             lights\n\nit contains lights that can literally fucking kill you if youre epileptic such as:\n-flashing lights\n-lights\nand stiff cocks\nthats it\n\npress escape to say \"go fuck yourself lights\"\npress enter to say \"lights stay\"", 32);
		warnText.setFormat(Paths.font("vcr.ttf"), 24, 0xFF644816, LEFT);
		warnText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2, 1);
		warnText.x = FlxG.width / 2;
		FlxG.sound.playMusic(Paths.music('flashingstate'), 1);
		add(warnText);

		Conductor.changeBPM(135);
		goober = new FlxSprite(15, 0, Paths.image('stop'));
		goober.screenCenter(Y);
		add(goober);

	}

	override public function beatHit() {
		super.beatHit();
		goober.angle = 0;
		FlxTween.cancelTweensOf(goober);
		FlxTween.tween(goober, {angle: 360}, Conductor.crochet / 1000, {ease: flixel.tweens.FlxEase.sineInOut});
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		myballs += elapsed;
		warnText.angle = Math.sin(myballs) * 2.5;
		warnText.y = (FlxG.height / 2 - warnText.height / 2) + Math.cos(myballs) * 5;
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				FlxG.sound.music.stop();
				FlxG.sound.music.destroy();
				FlxG.sound.music = null;
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.camera.zoom += 0.15;
				FlxTween.tween(FlxG.camera, {zoom: 1}, Conductor.crochet / 1000, {ease: flixel.tweens.FlxEase.expoOut});
				beatHit();
				if(back) {
					ClientPrefs.flashing = false;
					ClientPrefs.saveSettings();
					goober.loadGraphic(Paths.image('disagree'));
					FlxG.camera.flash(FlxColor.RED, 1);
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							Achievements.unlockAchievement('rude');
							MusicBeatState.switchState(new TitleState());
						}
					});
				} else {
					goober.loadGraphic(Paths.image('thumbsup'));
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxG.camera.flash(FlxColor.GREEN, 1);
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				}
			}
		}
		super.update(elapsed);
	}
}