package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var acceptImage:FlxGraphic = Paths.image('thumbsup');
	var backImage:FlxGraphic = Paths.image('disagree');

	var textY:Float = 0;

	var textSize:Int = 24;
	var delta:Float = 0;

	var warnText:FlxText;
	var bg:FlxSprite;
	var BACK(default, null):?;
	var ACCEPT(default, null):?;



	override function create()
	{
		super.create();
		FlxG.sound.playMusic(Paths.music('warningTheme'), 1, true);

		var fill:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		bg = new FlxSprite().loadGraphic(Paths.image('stop'));

		bg.setGraphicSize(-1, Std.int(FlxG.height));
		bg.updateHitbox();

		bg.x = FlxG.width - bg.width;
		bg.screenCenter(Y);

		warnText = new FlxText(0, 0, FlxG.width * .8, "hey, fucker, this mod contains       lights\n
			it contains lights that can literally fucking kill\nyou if you're epileptic, such as:\n-flashing lights\n-lights\nand stiff cocks\nthats it\n
			to keep the   lights press enter and say lights you can stay.\nif you want to disable them however press escape or backspace\n
			keep yourself safe", textSize);

		warnText.setFormat(Paths.font("comic.ttf"), textSize, FlxColor.GREEN, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, true);
		warnText.bold = true;

		warnText.screenCenter(Y);
		warnText.x = textSize;

		textY = warnText.y;

		add(fill);
		add(bg);

		add(warnText);
	}

	override function update(elapsed:Float)
	{
		FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.initialZoom, FlxG.camera.zoom, FlxMath.bound(1 - (elapsed * Math.PI), 0, 1));
		if (!leftState)
		{
			delta = (delta + (elapsed * 3)) % (Math.PI * 2);

			var accept:Bool = PlayerSettings.controls.is(ACCEPT);
			var back:Bool = PlayerSettings.controls.is(BACK);

			if (back || accept)
			{
				leftState = true;

				FlxTransitionableState.skipNextTransOut = true;
				FlxTransitionableState.skipNextTransIn = true;

				ClientPrefs.prefs.set('reducedMotion', back);
				ClientPrefs.prefs.set('flashWarning', true);

				ClientPrefs.prefs.set('flashing', accept);
				ClientPrefs.prefs.set('shaders', accept);

				ClientPrefs.saveSettings();
				FlxG.camera.zoom += .2;

				delta = 0;
				bg.loadGraphic(accept ? acceptImage : backImage);

				bg.setGraphicSize(-1, Std.int(FlxG.height));
				bg.updateHitbox();

				bg.x = FlxG.width - bg.width;
				bg.screenCenter(Y);

				FlxG.sound.music.stop();
				switch (accept)
				{
					default:
						{
							FlxG.sound.play(Paths.sound('cancelMenu'));
							FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
							{
								new FlxTimer().start(.5, function(tmr:FlxTimer)
								{
									MusicBeatState.switchState(new TitleState());
								});
							});
						}
					case true:
						{
							FlxG.sound.play(Paths.sound('confirmMenu'));
							FlxG.camera.flash(FlxColor.GREEN, 1);

							FlxFlicker.flicker(warnText, 1, .2, true, true, function(fkr:FlxFlicker)
							{
								FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
								{
									new FlxTimer().start(.5, function(tmr:FlxTimer)
									{
										MusicBeatState.switchState(new TitleState());
									});
								});
							});
						}
				}
			}
		}

		warnText.y = textY + (Math.sin(delta * 2) * 4);
		warnText.angle = Math.sin(delta);

		super.update(elapsed);
	}
}