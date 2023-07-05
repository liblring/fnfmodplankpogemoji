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

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"hey fucker this mod contains             lights\n
			\n
			it contains lights that can literally fucking kill you if youre epileptic such as:\n
			-flashing lights\n
			-lights\n
			and stiff cocks\n
			thats it\n
			\n
			press enter to say \"go fuck yourself lights\"\npress escape to say \"lights stay\"",
			32);
		warnText.setFormat(Paths.font("vcr.ttf"), 32, 0xFF644816, LEFT);
		warnText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2, 1);
		warnText.screenCenter(Y);
		FlxG.sound.playMusic(Paths.music('flashingstate'), 1);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				FlxG.sound.music.stop();
				FlxG.sound.music.destroy();
				FlxG.sound.music = null;
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					ClientPrefs.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}