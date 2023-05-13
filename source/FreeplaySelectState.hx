package;

#if discord_rpc
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;
using StringTools;

// i abuse ctrl + c ctrl + v
typedef FreeplayMenuButton = {
	var x:Int;
	var y:Int;
	var name:String;
}

class FreeplaySelectState extends MusicBeatState {
	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	public static var curSelected:Int = 0;
	var optionStuff:Array<FreeplayMenuButton> = [{x: 50, y: 50, name: 'mainstory'}, {x: 700, y: 50, name: 'freeplay'}];

	var mainstory:FlxSprite;
	var freeplay:FlxSprite;

	var canClick:Bool = true;

	override function create() {
		#if discord_rpc
		DiscordClient.changePresence("In the Freeplay", null);
		#end

		FlxG.mouse.visible = true;

		camGame = new FlxCamera();
		FlxG.cameras.reset(camGame);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		persistentUpdate = persistentDraw = true;

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionStuff.length)
		{
			var option:FreeplayMenuButton = optionStuff[i];
			trace(Paths.image('fpcategory/category-' + option.name));
			var menuItem:FlxSprite = new FlxSprite(option.x, option.y).loadGraphic(Paths.image('fpcategory/category-' + option.name));
			menuItem.ID = i;
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();
			menuItems.add(menuItem);
		}
		super.create();
	}

	function goToState() {
		canClick = false;
		switch(curSelected) {
			case 0:
				FreeplayState.donkeykongismyfavotrituemarvelsuperhero = 'mainstory';
			default:
				FreeplayState.donkeykongismyfavotrituemarvelsuperhero = 'freeplay';
		}
		MusicBeatState.switchState(new FreeplayState(FreeplayState.donkeykongismyfavotrituemarvelsuperhero));
	}

	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.8) {
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		menuItems.forEach(function(spr:FlxSprite) {
			if (canClick) {
				if (controls.BACK) {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					MusicBeatState.switchState(new MainMenuState);
				}

				if (FlxG.mouse.overlaps(spr)) {
					curSelected = spr.ID;

					if (FlxG.mouse.pressed) {
						goToState();
					}
				}
			}
		});

		super.update(elapsed);
	}
}
