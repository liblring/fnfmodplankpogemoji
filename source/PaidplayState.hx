package;

#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import flixel.group.FlxSpriteGroup;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end
import openfl.text.TextFormat;

using StringTools;

class PaidplayState extends MusicBeatState
{
	var songs:Array<haxe.extern.EitherType<SongMetadata, String>> = [];

	var selector:FlxText;
	private static var lastSelected:Int = 1; // not 0 because im dumb and too lazy to ąóęąśłęóąśłęóąśóęą
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;
	var twobullshits:FlxSprite;
	var ermmmmwhatdatuna:FlxSprite;

	private var grpOptions:MenuList;
	private var curPlaying:Bool = false;
	var flixelcangokillitself:FlxSprite = new FlxSprite();

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("it is gonna song yes", null);
		#end

		for (i in 0...WeekData.weeksList.length) {
			if(weekIsLocked(WeekData.weeksList[i])) continue;
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);

			songs.push(leWeek.weekName);

			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
					colors = [146, 113, 253];
				songs.push(new SongMetadata(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2])));
			}
		}
		WeekData.loadTheFirstEnabledMod();

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = PlankPrefs.data.globalAntialiasing;
		add(bg);
		bg.screenCenter();
		bg.color = 0xFF828282;

		grpOptions = new MenuList(0, 0, VERTICAL(true));
		grpOptions.moveDirection.x = 0.15;
		grpOptions.focused = true;
		grpOptions.moveWithCurSelection = true;
		grpOptions.padding = 50;
		grpOptions.x = 100;
		grpOptions.onMove.add(changeSelection);
		grpOptions.screenCenter(Y);
		grpOptions.onSelect.add((sel) -> {
			lastSelected = sel;
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(cast (songs[grpOptions.curSelection], SongMetadata).songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			if(colorTween != null) {
				colorTween.cancel();
			}
			
			if (FlxG.keys.pressed.SHIFT){
				LoadingState.loadAndSwitchState(ChartingState);
			}else{
				LoadingState.loadAndSwitchState(PlayState);
			}

			FlxG.sound.music.volume = 0;
					
			destroyFreeplayVocals();
		});
		add(grpOptions);

		for (song in songs)
		{
			if (song is String) {
				var optionText:FlxText = new FlxText(0, 0, 500, cast (song, String));
				optionText.setFormat(Paths.font('vcr.ttf'), 42, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.WHITE);
				optionText.setBorderStyle(OUTLINE, 	FlxColor.BLACK, 4, 2);
				optionText.active = false;
				grpOptions.add(optionText);
				continue;
			}

			var songText:FlxText = new FlxText(0, 0, 500, cast (song, SongMetadata).songName);
			songText.setFormat(Paths.font('vcr.ttf'), 42, FlxColor.BLACK, LEFT, OUTLINE, FlxColor.WHITE);
			songText.setBorderStyle(OUTLINE, 	FlxColor.WHITE, 4, 2);

			var icon:HealthIcon = new HealthIcon(cast (song, SongMetadata).songCharacter);
			icon.setPosition(songText.text.length * (42 / 2) + 12, songText.height / 2 - icon.height / 2);
			icon.flipX = icon.char == "zlibty";

			var idiot:FlxSpriteGroup = new FlxSpriteGroup();
			idiot.add(icon);
			idiot.add(songText);

			grpOptions.add(idiot);

			if(grpOptions.members[grpOptions.curSelection].active == false) grpOptions.curSelection = songs.indexOf(song);
		}
		WeekData.setDirectoryFromWeek();

		add(ermmmmwhatdatuna = new FlxSprite(0, 0, Paths.image('paidplay/bigbonerdownthelane/placeholder')));
		ermmmmwhatdatuna.x = FlxG.width - ermmmmwhatdatuna.width;
		
		add(new FlxSprite(481, 0, Paths.image('paidplay/lin e')));

		Main.fpsVar.defaultTextFormat = new TextFormat("Lato", 18, 0xFFFFFFFF, null, null, null, null, null, RIGHT);

		twobullshits = new FlxSprite().loadGraphic(Paths.image('these-fuckers'));
		twobullshits.antialiasing = PlankPrefs.data.globalAntialiasing;
		twobullshits.scale.set(1.05, 1.05);
		add(grpOptions);
		add(twobullshits);

		scoreText = new FlxText(5, 5, FlxG.width - 10, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT);

		diffText = new FlxText(5, 0, FlxG.width - 10, "", 24);
		diffText.y = FlxG.height - diffText.height;
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		if(lastDifficultyName == '')
			lastDifficultyName = CoolUtil.defaultDifficulty;
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		grpOptions.curSelection = lastSelected;
		changeSelection();
		changeDiff();

		super.create();
	}

	override function closeSubState() {
		if (FlxG.state.subState is ShatterTransition) return super.closeSubState();
		changeSelection(0);
		persistentUpdate = true;
		super.closeSubState();
	}

	override public function destroy() {
		super.destroy();
		Main.fpsVar.defaultTextFormat = new TextFormat("Lato", 18, 0xFFFFFFFF, null, null, null, null, null, LEFT);
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'personale - ' + lerpScore + ' (' + ratingSplit.join('.');

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);
		else if (upP || downP) changeDiff();

		if (controls.BACK)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if(ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(space)
		{
			if(instPlaying != grpOptions.curSelection)
			{
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				var sogn:SongMetadata = cast (songs[grpOptions.curSelection], SongMetadata);
				Paths.currentModDirectory = sogn.folder;
				var poop:String = Highscore.formatSong(sogn.songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, sogn.songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();

				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				instPlaying = grpOptions.curSelection;
				#end
			}
		}

		/*else if (accepted)
		{

		}
		else if(controls.RESET)
		{
			persistentUpdate = false;
			// openSubState(new ResetScoreSubState(songs[grpOptions.curSelection].songName, curDifficulty, songs[grpOptions.curSelection].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}*/
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		diffText.visible = CoolUtil.difficulties.length > 1;
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		var sogn:SongMetadata = cast (songs[grpOptions.curSelection], SongMetadata);
		intendedScore = Highscore.getScore(sogn.songName, curDifficulty);
		intendedRating = Highscore.getRating(sogn.songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		var sogn:SongMetadata = cast (songs[grpOptions.curSelection], SongMetadata);
		var newColor:Int = sogn.color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(flixelcangokillitself, 1, flixelcangokillitself.color, newColor, {onUpdate: (twn) -> bg.color = flixelcangokillitself.color, onComplete: (twn) -> colorTween = null});
		}

		// selector.y = (70 * grpOptions.curSelection) + 30;

		#if !switch
		intendedScore = Highscore.getScore(sogn.songName, curDifficulty);
		intendedRating = Highscore.getRating(sogn.songName, curDifficulty);
		#end
		
		Paths.currentModDirectory = sogn.folder;
		PlayState.storyWeek = sogn.week;

		var ermmwhattheblast:String = (Paths.fileExists('images/paidplay/bigbonerdownthelane/${sogn.songName}.png', IMAGE) ? 'paidplay/bigbonerdownthelane/${sogn.songName}' : 'paidplay/bigbonerdownthelane/placeholder');
		ermmmmwhatdatuna.loadGraphic(Paths.image(ermmwhattheblast));

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
		changeDiff();
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}
