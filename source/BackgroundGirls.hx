package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class BackgroundGirls extends FlxSprite
{
	var isPissed:Bool = true;
	public function new(x:Float, y:Float)
	{
		super(x, y);

		// BG fangirls dissuaded
		frames = Paths.getSparrowAtlas('weeb/bgFreaks');

		swapDanceType();

		animation.play('danceLeft');
	}

	var danceDir:Bool = false;

	public function swapDanceType():Void
	{
		isPissed = !isPissed;
		var prefix:String = (isPissed ? 'BG fangirls dissuaded' : 'BG girls group');

		animation.addByIndices('danceLeft', prefix, CoolUtil.numberArray(14), "", 24, false);
		animation.addByIndices('danceRight', prefix, CoolUtil.numberArray(30, 15), "", 24, false);

		dance();
	}

	public function dance():Void
	{
		danceDir = !danceDir;

		animation.play('dance' + (danceDir ? 'Right' : 'Left'), true);
	}
}
