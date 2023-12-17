package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;

class DumbassWaringScreenState extends FlxState {
	override public function create() {
		super.create();
		add(new FlxSprite(0, 0, Paths.image('dumb')));

		FlxG.camera.fade(0xFF000000, 1, true, () ->
				new FlxTimer().start(3.5, (_) -> FlxG.camera.fade(0xFF000000, 1, false, () -> {
						if (FlxG.save.data.flashing == null) FlxG.switchState(new FlashingState());
						else FlxG.switchState(new TitleState());
					}
				)
			)
		);
	}
}