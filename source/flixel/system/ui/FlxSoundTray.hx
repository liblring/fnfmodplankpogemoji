package flixel.system.ui;

#if FLX_SOUND_SYSTEM
import flixel.FlxG;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.display.Shape;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import haxe.Timer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import windowblinds.Windowblinds;

/**
 * The flixel sound tray, the little volume meter that pops down sometimes.
 * Accessed via `FlxG.game.soundTray` or `FlxG.sound.soundTray`.
 */
class FlxSoundTray extends Sprite
{

	public var active:Bool;

	/** Whether or not changing the volume should make noise. **/
	public var silent:Bool = false;
	
	var volumeText:TextField;

	public function new()
	{
		super();

		volumeText = new TextField();
		volumeText.y = 4;
		volumeText.x = 4;
		volumeText.multiline = false;
		volumeText.wordWrap = false;
		volumeText.selectable = false;

		volumeText.defaultTextFormat = new TextFormat(Paths.font('segoeui.ttf'), 16, 0xFFFFFF);
		volumeText.defaultTextFormat.align = TextFormatAlign.LEFT;
		addChild(volumeText);
		volumeText.text = "0%";

		x = 8;
		active = visible = false;
		screenCenter();
	}

	public var barThickness:Int = 5;
	public var barHeight:Int = 15;

	public function redrawBar() {
		graphics.clear();
		graphics.beginFill(Windowblinds.borderColor, 0.2);
		graphics.drawRoundRect(0, 0, FlxG.stage.window.width - 16, 35, 5);
		graphics.endFill();

		var barWidth:Float = width - volumeText.textWidth - 44;

		graphics.beginFill(0xFFFFFF, 0.2);
		graphics.drawRoundRect(volumeText.textWidth + 16, 8, barWidth, 35 - 16, 5);
		graphics.endFill();

		graphics.beginFill(0xFFFFFF, 1);
		graphics.drawRoundRect(volumeText.textWidth + 16, 8, barWidth * FlxG.sound.volume, 35 - 16, 5);
		graphics.endFill();
	}

	public function screenCenter() {
		volumeText.width = FlxG.stage.window.width;
		redrawBar();
		y = FlxG.stage.window.height - 8 - 35;
		// :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 
	}

	public function update(delta:Float):Void {}

	public function show(up:Bool = false):Void {
		active = visible = true;
		if (FlxG.save.isBound) {
			FlxG.save.data.mute = FlxG.sound.muted;
			FlxG.save.data.volume = FlxG.sound.volume;
			FlxG.save.flush();
		}

		if (!silent) {
			var sound = Paths.sound((up ? 'volumeUp' : 'volumeDown'));
			if (sound != null)
				FlxG.sound.load(sound).play().pitch = (1 + (Math.random() / 6));
		}

		volumeText.text = '${Math.round(FlxG.sound.volume * 100) * (FlxG.sound.muted ? 0 : 1)}%';
		redrawBar();
		Main.border.timeout();
	}
}
#end