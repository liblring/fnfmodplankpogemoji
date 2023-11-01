package;

import Conductor.BPMChangeEvent as BPMChangeEvent;
import flixel.FlxG as FlxG;
import flixel.addons.ui.FlxUIState as FlxUIState;
import flixel.math.FlxRect as FlxRect;
import flixel.util.FlxTimer as FlxTimer;
import flixel.addons.transition.FlxTransitionableState as FlxTransitionableState;
import flixel.tweens.FlxEase as FlxEase;
import flixel.tweens.FlxTween as FlxTween;
import flixel.FlxSprite as FlxSprite;
import flixel.util.FlxColor as FlxColor;
import flixel.util.FlxGradient as FlxGradient;
import flixel.FlxState as FlxState;
import flixel.FlxCamera as FlxCamera;
import flixel.FlxBasic as FlxBasic;
import openfl.display.BitmapData as BitmapData;
import lime.math.Rectangle as Rectangle;

class MusicBeatState extends FlxUIState
{
	var curSection:Int = 0;
	var stepsToDo:Int = 0;
	var curStep:Int = 0;
	var curBeat:Int = 0;
	var curDecStep:Float = 0;
	var curDecBeat:Float = 0;
	var controls(get, never):Controls;
	var pastStateBitmap:BitmapData;

	public static var camBeat:FlxCamera;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;


	public function new() {
		super();

		var pastVisibleYourMom:Bool = Main.fpsVar.visible;
		Main.fpsVar.visible = false;
		// todo: refactor this so it acounts in when the player resizes the window
		pastStateBitmap = BitmapData.fromImage(FlxG.stage.window.readPixels());
		Main.fpsVar.visible = pastVisibleYourMom;

	}

	override function create() {
		camBeat = FlxG.camera;
		super.create();
		// if (!FlxTransitionableState.skipNextTransOut)
			openSubState(new ShatterTransition(pastStateBitmap));
	}

	override public function destroy() {
		pastStateBitmap.dispose();
		super.destroy();
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if(curStep > 0)
				stepHit();

			if(PlayState.SONG != null)
			{
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}

		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;

		super.update(elapsed);
	}

	function updateSection():Void
	{
		if(stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while(curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	function rollbackSection():Void
	{
		if(curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;
				
				curSection++;
			}
		}

		if(curSection > lastSection) sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public static function switchState(nextState:FlxState) {
		// Custom made Trans in
		var curState:FlxState = cast FlxG.state;

		if(nextState == FlxG.state)
			FlxG.resetState();
		else
			FlxG.switchState(nextState);
	}

	public static function resetState() {
		MusicBeatState.switchState(FlxG.state);
	}

	public static function getState():MusicBeatState {
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		return leState;
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//trace('Beat: ' + curBeat);
	}

	public function sectionHit():Void
	{
		//trace('Section: ' + curSection + ', Beat: ' + curBeat + ', Step: ' + curStep);
	}

	function getBeatsOnSection() {
		var val:Null<Float> = 4; 
		try val = PlayState.SONG.notes[curSection].sectionBeats catch(e) {}
		return val;
	}
}
