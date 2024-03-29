package openfl.display;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.tweens.FlxEase;
import flixel.FlxG;
// #if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
// #end
#if flash
import openfl.Lib;
#end

#if openfl
import openfl.system.System;
#end

class FPS extends Sprite {
	//The current frame rate, expressed using frames-per-second

	public var currentFPS(default, null):Int;

	private var currentMemory:Float;
	private var maxMemory:Float;

	private var maxColor:FlxColor = 0xFFEC5454;
	private var normalColor:FlxColor = 0xFFFFFFFF;
	private var outlineColor:FlxColor = 0xFF000000;
	public var baseText:TextField;
	public var outlineTexts:Array<TextField> = [];
	private var outlineWidth:Int = 2;
	private var outlineQuality:Int = 8;
	public var defaultTextFormat(default, set):TextFormat;

	public var text(default, set):String; 


	public function new(x:Float = 10, y:Float = 10) {
		super();

		this.x = x;
		this.y = y;


		baseText = new TextField();
		baseText.selectable = false;
		baseText.mouseEnabled = false;
		baseText.width = FlxG.width - x * 2;

		currentFPS = 0;
		currentMemory = 0;
		maxMemory = 0;

		for (i in 0...outlineQuality) {
			var otext:TextField = new TextField();
			otext.x = Math.sin(i) * outlineWidth;
			otext.y = Math.cos(i) * outlineWidth;
			otext.textColor = outlineColor;
			otext.selectable = false;
			otext.mouseEnabled = false;
			otext.width = baseText.width;
			outlineTexts.push(otext);
			addChild(otext);
		}

		addChild(baseText);

		text = "FPS: ";
		this.defaultTextFormat = new TextFormat("Lato", 18, normalColor);

	}

	var anusTime:Float = 0; 

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void {
		var curTime = Sys.time();
		currentFPS = Math.floor(1 / (curTime - anusTime));


		// #if (gl_stats && !disable_cffi && (!html5 || !canvas))
		// #end

		var stats = System.totalMemory;
		currentMemory = stats;
		if (currentMemory > maxMemory)
			maxMemory = currentMemory;

		text = 'pfs: ${currentFPS}\n;emory: ${FlxStringUtil.formatBytes(currentMemory)} / ${FlxStringUtil.formatBytes(maxMemory)}';
		// text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
		// text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
		// text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);

		var mappedFPS = FlxMath.remapToRange(currentFPS, FlxG.drawFramerate, 0, 0, 1);

		baseText.textColor = FlxColor.interpolate(normalColor, maxColor, FlxEase.cubeIn(mappedFPS));
		anusTime = curTime;
	}

	private function set_text(value:String):String {
		baseText.text = value;
		for (text in outlineTexts) {
			text.text = value;
		}
		return text = value;
	}

	private function set_defaultTextFormat(format:TextFormat):TextFormat {
		baseText.defaultTextFormat = format;
		for (text in outlineTexts) {
			text.defaultTextFormat = format;
			text.textColor = outlineColor;
		}
		return defaultTextFormat = format;
	}
}