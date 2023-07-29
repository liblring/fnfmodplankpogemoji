package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxSpriteGroup;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;
import flxgif.FlxGifSprite;
import flixel.util.typeLimit.OneOfTwo;

using StringTools;

class CreditsState extends MusicBeatState
{
	private var grpOptions:MenuList;
	private var iconArray:Array<FlxSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var corn:FlxSprite;
	var iamscreamingandcreaming:FlxText;
	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var outlin:OutlineShader = new OutlineShader();
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	override function create()
	{
		outlin.outlineSize = 12;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("hold on let him see the devs", null);
		#end

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);
		bg.screenCenter();
		
		grpOptions = new MenuList(0, 0, VERTICAL(true));
		grpOptions.focused = true;
		grpOptions.moveWithCurSelection = true;
		grpOptions.padding = 50;
		grpOptions.x = 100;
		grpOptions.onMove.add(changeSelection);
		grpOptions.screenCenter(Y);
		grpOptions.onSelect.add((sel) -> if (creditsStuff[sel][3] != null) CoolUtil.browserLoad(creditsStuff[sel][3]));
		add(grpOptions);

		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color - image folder
			['lario forest'],
			['libing',	'lib',		'director or some shit i forgot (im on crack while writing this)',							'https://www.youtube.com/channel/UCwH4gcjdN-gWPGunlBxAnQQ',	'ffcaca', 'liber'],
			['PlankDev','plank',    'coder + like composer + like the guy who turned this into a serious mod bravo plank!',		'https://github.com/ThePlank',		'4a2e00', 'plnk'],
			['Nick',    'dantesguy','coder + like artist + like animator, made opd sprites for mnalk lets fokin go mate innit',	'https://github.com/Nikerlo',		'ffffff'],
			['FlyingFeltBoot','flyingfeltwhat','help with random bullshit like hypothesis dantes sprites i guess',	'https://github.com/Nikerlo',		'7a4a35'],
			[''],
			['d'],
			['d',	'd',		'd (dont press enter)',							'https://www.youtube.com/watch?v=mYiBdMnIT88',	'FFFF00', 'd'],
			[''],
			['Shadow Mario Team'],
			['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',								'https://twitter.com/Shadow_Mario_',	'444444'],
			['Shadow Mario',		'shadowmario',		'Shadow Mario',			                    					'https://twitter.com/Shadow_Mario_',	'444444'],
			['Shadow Mario',		'shadowmario',		'The Best BLJer On The Earth',				    				'https://twitter.com/Shadow_Mario_',	'444444'],
			[''],
			['Former Shadow Mario'],
			['Shadow Mario',		'shadowmario',		'Created Shadow Mario and then left wtf',						'https://twitter.com/Shadow_Mario_',	'444444'],
			[''],
			['Shadow Mario Contributors'],
			['Shadow Mario',		'shadowmario',		'Shadow Mario`s Dad',								'https://twitter.com/Shadow_Mario_',	'444444'],
			['Shadow Mario',		'shadowmario',		'Shadow Mario`s Mom',								'https://twitter.com/Shadow_Mario_',	'444444'],
			['Shadow Mario',		'shadowmario',		'Shadow Mario`s Grandpa',								'https://twitter.com/Shadow_Mario_',	'444444'],
			['Shadow Mario',		'shadowmario',		'Shadow Mario`s Grandma',								'https://twitter.com/Shadow_Mario_',	'444444'],
			['Shadow Mario',		'shadowmario',		'Shadow Mario`s Grandgrandpa',								'https://twitter.com/Shadow_Mario_',	'444444'],
			['Keoiki',				'keoiki',			'help me im stuck in the infinite field of shadow mario',		'https://twitter.com/Keoiki_',			'D2D2D2'],
			['Shadow Mario',		'shadowmario',		'Shadow Mario`s Grandgrandma',								'https://twitter.com/Shadow_Mario_',	'444444'],
			['Shadow Mario',		'shadowmario',		'Shadow Mario`s Uncle',								'https://twitter.com/Shadow_Mario_',	'444444'],
			[''],
			["Shadow Lario Crew"],
			['Shadow Mario',		'shadowmario',		'everybody wanna be a shadow mario',								'https://twitter.com/Shadow_Mario_',	'444444'],
			['Shadow Mario',		'shadowmario',		'get a lotta engines drive in fancy codes',								'https://twitter.com/Shadow_Mario_',	'444444'],
			['Shadow Mario',		'shadowmario',		'everybody wanna be a shadow mario',								'https://twitter.com/Shadow_Mario_',	'444444'],
			['Shadow Mario',		'shadowmario',		'idk whats the 4th lyric but shadow mario',								'https://twitter.com/Shadow_Mario_',	'444444']
		];
		
		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:FlxText = new FlxText(0, 0, 500, creditsStuff[i][0]);
			optionText.setFormat(Paths.font('vcr.ttf'), 42, FlxColor.BLACK, LEFT, OUTLINE, FlxColor.WHITE);
			optionText.setBorderStyle(OUTLINE, 	FlxColor.WHITE, 4, 2);
			optionText.active = isSelectable;

			if(isSelectable) {
				var icon:FlxSprite = new FlxSprite(optionText.text.length * (42 / 2) + 12, 0, Paths.image('credits/' + creditsStuff[i][1]));
				icon.y = optionText.height / 2 - icon.height / 2;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				var idiot:FlxSpriteGroup = new FlxSpriteGroup();
				idiot.add(icon);
				idiot.add(optionText);
				grpOptions.add(idiot);

				if(grpOptions.members[grpOptions.curSelection].active == false) grpOptions.curSelection = i;
			} else {
				optionText.setFormat(Paths.font('vcr.ttf'), 42, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.WHITE);
				optionText.setBorderStyle(OUTLINE, 	FlxColor.BLACK, 4, 2);
				grpOptions.add(optionText);
			} 
		}

		add(new FlxSprite().loadGraphic(Paths.image('creditorial!!!/femboyfg')));
		
		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		FlxG.sound.playMusic(Paths.music('creditsbyfrums'), 1, true);
		Conductor.changeBPM(94);

		iamscreamingandcreaming = new FlxText(0, 0, 0, 'random image selected by the dev');
		iamscreamingandcreaming.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		iamscreamingandcreaming.borderSize = 2.4;

		bg.color = getCurrentBGColor();
		intendedColor = bg.color;

		changeSelection(grpOptions.curSelection);

		super.create();
	}

	override public function beatHit() {
		super.beatHit();
		FlxG.camera.zoom += 0.02;
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, 0.15);

		if(!quitting)
		{
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
				quitting = true;
			}
		}
		
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(curSelected:Int)
	{
		var newColor:Int =  getCurrentBGColor();
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 0.75, bg.color, intendedColor, { ease: FlxEase.expoOut,
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.expoOut});
		if (creditsStuff[curSelected][5] != null) {
			var femboyPath:String = FileSystem.absolutePath('assets\\images\\creditorial!!!\\yow\\${creditsStuff[curSelected][5]}');
			var tomboyFiles:Array<String> = FileSystem.readDirectory(femboyPath);
			var gexed:String = femboyPath + '\\${tomboyFiles[FlxG.random.int(0, tomboyFiles.length - 1)]}';
			commitHateCrime(gexed);
		}  else {
			corn.visible = false;
		}

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	function commitHateCrime(pathShit:String):Void {
		if (corn != null) corn.destroy();
		corn = new FlxSprite();
		corn.loadGraphic(Paths.directGraphic(pathShit));
		add(corn);

		if (corn.height > 353) corn.setGraphicSize(0, 353);
		corn.updateHitbox();
		corn.setPosition(FlxG.width * 0.6, 0);
		corn.screenCenter(Y);
		corn.shader = outlin;
		iamscreamingandcreaming.fieldWidth = corn.width;
		iamscreamingandcreaming.setPosition(FlxG.width * 0.6, corn.y);
		iamscreamingandcreaming.y -= iamscreamingandcreaming.height;
		add(iamscreamingandcreaming);
	}


	#if MODS_ALLOWED
	private var modsAdded:Array<String> = [];
	function pushModCreditsToList(folder:String)
	{
		if(modsAdded.contains(folder)) return;

		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
		modsAdded.push(folder);
	}
	#end

	function getCurrentBGColor() {
		var bgColor:String = creditsStuff[grpOptions.curSelection][4];
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}