package;

import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import haxe.io.Path;
import openfl.display.BitmapData;
import sys.FileSystem;

class LoadingState extends MusicBeatState
{
	inline static var MIN_TIME = 1.0;

	// Browsers will load create(), you can make your song load a custom directory there
	// If you're compiling to dajlhgldkdhglah (or something that doesn't use NO_PRELOAD_ALL), search for getNextState instead
	// I'd recommend doing it on both actually lol
	// TO DO: Make this easier
	var target:Class<FlxState>;
	var targetArgs:Array<Dynamic>;
	var showLoading:Bool;
	var stopMusic = false;
	var directory:String;
	var callbacks:MultiCallback;
	var targetShit:Float = 0;

	function new(target:Class<FlxState>, targetArgs:Array<Dynamic>, showLoading:Bool, stopMusic:Bool, directory:String) {
		super();
		this.target = target;
		this.targetArgs = targetArgs;
		this.showLoading = showLoading;
		this.stopMusic = stopMusic;
		this.directory = directory;
	}

	var funkay:FlxSprite;
	var loadBar:FlxSprite;
	var souddn:FlxSound;

	override function create() {
		if (showLoading) openSubState(new ShatterTransition(pastStateBitmap));
		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xffcaff4d);
		add(bg);

		var imagePath:String = FileSystem.absolutePath('assets\\images\\hdgfhdgfhgdhfgdhfgdhgfhdgfhdgfhdgfhdgfhdghfgdhfghdgfhdghfghfgdhgfhdgfhdg');
		var tomboyFiles:Array<String> = FileSystem.readDirectory(imagePath);
		var hdfg:Int = FlxG.random.int(0, tomboyFiles.length - 1);

		funkay = new FlxSprite(0, 0, Paths.directGraphic('$imagePath\\${tomboyFiles[hdfg]}'));
		funkay.setGraphicSize(FlxG.width, FlxG.height);
		funkay.updateHitbox();
		funkay.antialiasing = PlankPrefs.data.globalAntialiasing;
		add(funkay);
		funkay.scrollFactor.set();
		funkay.screenCenter();

		if (Paths.fileExists('sounds/LOAD/${Path.withoutExtension(tomboyFiles[hdfg])}.ogg', SOUND))
			souddn = FlxG.sound.load(Paths.sound('LOAD/${Path.withoutExtension(tomboyFiles[hdfg])}'));

		loadBar = new FlxSprite(0, FlxG.height - 20).makeGraphic(FlxG.width, 10, 0xffff16d2);
		loadBar.screenCenter(X);
		loadBar.antialiasing = PlankPrefs.data.globalAntialiasing;
		add(loadBar);

		FlxG.camera.zoom = 1.1;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 0.75, {ease: FlxEase.quartInOut});

		initSongsManifest().onComplete((lib) -> {

			callbacks = new MultiCallback(onLoad);
			var introComplete = callbacks.add("introComplete");
			if (souddn != null) {
				var soundComplete = callbacks.add("soundComplete");
				souddn.onComplete = soundComplete;
				souddn.play();
			}

			checkLibrary("shared");
			if (directory != null && directory.length > 0 && directory != 'shared')
				checkLibrary(directory);

			var fadeTime = 0.5;
			if (showLoading) {
				FlxG.camera.fade(FlxG.camera.bgColor, fadeTime, true);
				new FlxTimer().start(fadeTime + MIN_TIME, function(_) introComplete()); 
			} else introComplete();
		});
	}

	function checkLoadSong(path:String) {
		if (!Assets.cache.hasSound(path))
		{
			var library = Assets.getLibrary("songs");
			final symbolPath = path.split(":").pop();
			// @:privateAccess
			// library.types.set(symbolPath, SOUND);
			// @:privateAccess
			// library.pathGroups.set(symbolPath, [library.__cacheBreak(symbolPath)]);
			var callback = callbacks.add("song:" + path);
			Assets.loadSound(path).onComplete(function(_)
			{
				callback();
			});
		}
	}

	function checkLibrary(library:String) {
		if (Assets.getLibrary(library) == null)
		{
			@:privateAccess
			if (!LimeAssets.libraryPaths.exists(library))
				throw "Missing library: " + library;

			var callback = callbacks.add("library:" + library);
			Assets.loadLibrary(library).onComplete(function(_)
			{
				callback();
			});
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (callbacks != null) {
			targetShit = FlxMath.remapToRange(callbacks.numRemaining / callbacks.length, 1, 0, 0, 1);
			loadBar.scale.x += 0.5 * (targetShit - loadBar.scale.x);
		}
	}

	function onLoad() {
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		MusicBeatState.switchState(createYourMother(target, targetArgs));
	}

	static function getSongPath()
		return Paths.instPath(PlayState.SONG.song);

	static function getVocalPath()
		return Paths.voicesPath(PlayState.SONG.song);

	inline static public function loadAndSwitchState(target:Class<FlxState>, showLoading = true, ?args, stopMusic = false)
		MusicBeatState.switchState(getNextState(target, showLoading, args, stopMusic));

	static function getNextState(target:Class<FlxState>, showLoading = true, args:Array<Dynamic>, stopMusic = false):FlxState {
		if (args == null) args = [];
		var directory:String = 'shared';
		var weekDir:String = StageData.forceNextDirectory;
		StageData.forceNextDirectory = null;

		if (weekDir != null && weekDir.length > 0 && weekDir != '')
			directory = weekDir;

		Paths.setCurrentLevel(directory);
		trace('Setting asset folder to ' + directory);

		var loaded:Bool = false;
		if (PlayState.SONG != null)
		{
			loaded = isSoundLoaded(getSongPath())
				&& (!PlayState.SONG.needsVoices || isSoundLoaded(getVocalPath()))
				&& isLibraryLoaded("shared")
				&& isLibraryLoaded(directory);
		}

		if (!loaded)
			return new LoadingState(target, args, showLoading, stopMusic, directory);
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		return createYourMother(target, args);
	}

	static public function createYourMother(target:Class<FlxState>, args:Array<Dynamic>):FlxState
		return Type.createInstance(target, args);

	static function isSoundLoaded(path:String):Bool
		return Assets.cache.hasSound(path);

	static function isLibraryLoaded(library:String):Bool
		return Assets.getLibrary(library) != null;

	override function destroy() {
		super.destroy();
		callbacks = null;
	}

	static function initSongsManifest() {
		var id = "songs";
		var promise = new Promise<AssetLibrary>();

		var library = LimeAssets.getLibrary(id);

		if (library != null)
		{
			return Future.withValue(library);
		}

		var path = id;
		var rootPath = null;

		@:privateAccess
		var libraryPaths = LimeAssets.libraryPaths;
		if (libraryPaths.exists(id))
		{
			path = libraryPaths[id];
			rootPath = Path.directory(path);
		}
		else
		{
			if (StringTools.endsWith(path, ".bundle"))
			{
				rootPath = path;
				path += "/library.json";
			}
			else
			{
				rootPath = Path.directory(path);
			}
			@:privateAccess
			path = LimeAssets.__cacheBreak(path);
		}

		AssetManifest.loadFromFile(path, rootPath).onComplete(function(manifest)
		{
			if (manifest == null)
			{
				promise.error("Cannot parse asset manifest for library \"" + id + "\"");
				return;
			}

			var library = AssetLibrary.fromManifest(manifest);

			if (library == null)
			{
				promise.error("Cannot open library \"" + id + "\"");
			}
			else
			{
				@:privateAccess
				LimeAssets.libraries.set(id, library);
				library.onChange.add(LimeAssets.onChange.dispatch);
				promise.completeWith(Future.withValue(library));
			}
		}).onError(function(_)
		{
				promise.error("There is no asset library with an ID of \"" + id + "\"");
		});

		return promise.future;
	}
}

class MultiCallback {
	public var callback:Void->Void;
	public var logId:String = null;
	public var length(default, null) = 0;
	public var numRemaining(default, null) = 0;

	var unfired = new Map<String, Void->Void>();
	var fired = new Array<String>();

	public function new(callback:Void->Void, logId:String = null) {
		this.callback = callback;
		this.logId = logId;
	}

	public function add(id = "untitled") {
		id = '$length:$id';
		length++;
		numRemaining++;
		var func:Void->Void = null;
		func = function()
		{
			if (unfired.exists(id))
			{
				unfired.remove(id);
				fired.push(id);
				numRemaining--;

				if (logId != null)
					log('fired $id, $numRemaining remaining');

				if (numRemaining == 0)
				{
					if (logId != null)
						log('all callbacks fired');
					callback();
				}
			}
			else
				log('already fired $id');
		}
		unfired[id] = func;
		return func;
	}

	inline function log(msg):Void
		if (logId != null)
			trace('$logId: $msg');

	public function getFired()
		return fired.copy();

	public function getUnfired()
		return [for (id in unfired.keys()) id];
}
