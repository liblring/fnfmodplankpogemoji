package;

import flixel.FlxG;
import openfl.display.BitmapData;
import flixel.FlxSprite;
import flixel.addons.display.FlxRuntimeShader;

class ShatterTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	public static var idiotShader:FlxRuntimeShader = new FlxRuntimeShader('
	#pragma header

	uniform sampler2D mask;
	void main(void) {
		vec4 texel = flixel_texture2D(mask, openfl_TextureCoordv);
		texel.rgb = flixel_texture2D(bitmap, openfl_TextureCoordv).rgb;
		if (texel.a > 0.0)
			gl_FragColor = texel;
		else
			gl_FragColor = vec4(0., 0., 0., 0.);
	}
	');
	private var shatterMask:FlxSprite;
	private var transitionSprite:FlxSprite;

	public function new(pastStateImage:BitmapData) {
		super();

		transitionSprite = new FlxSprite(0, 0, pastStateImage);
		transitionSprite.scrollFactor.set();

		transitionSprite.shader = idiotShader;

		shatterMask = new FlxSprite(0, 0);
		shatterMask.frames = Paths.getSparrowAtlas('glassShatter');
		shatterMask.animation.addByPrefix('shatter', 'shatter', 24, false);
		shatterMask.animation.play('shatter');

		shatterMask.animation.callback = (name, fn, fi) -> {
			shatterMask.updateFramePixels();
			idiotShader.setSampler2D('mask', shatterMask.framePixels);
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