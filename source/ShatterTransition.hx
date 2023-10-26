package;

import flixel.FlxG;
import openfl.display.BitmapData;
import flixel.FlxSprite;
import flixel.addons.display.FlxRuntimeShader;

class ShatterTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	public static var idiotShader:AlphaMaskShader = new AlphaMaskShader();
	private var shatterMask:FlxSprite;
	private var transitionSprite:FlxSprite;

	public function new(pastStateImage:BitmapData) {
		super();

		transitionSprite = new FlxSprite(0, 0, pastStateImage);
		transitionSprite.scrollFactor.set();

		transitionSprite.setGraphicSize(FlxG.width, FlxG.height);

		transitionSprite.shader = idiotShader;

		shatterMask = new FlxSprite(0, 0);
		shatterMask.frames = Paths.getSparrowAtlas('glassShatter');
		shatterMask.animation.addByPrefix('shatter', 'shatter', 24, false);
		shatterMask.animation.play('shatter');

		shatterMask.animation.callback = (name, fn, fi) -> {
			shatterMask.updateFramePixels();
			idiotShader.data.mask.input = shatterMask.framePixels;
		}
		
		shatterMask.animation.finishCallback = (name) -> {
			pastStateImage.dispose();
			transitionSprite.destroy();
			shatterMask.destroy();
			close();
		}

		add(shatterMask);
		add(transitionSprite);

		camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
	}
}