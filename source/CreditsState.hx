package;

import flixel.FlxCamera;
#if desktop
import Discord.DiscordClient;
#end
//import flash.text.TextField; //unused //used import????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? guys wtf
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
import sys.FileSystem;
import sys.io.File;
import lime.utils.Assets;
import flxgif.FlxGifSprite;
import flixel.util.typeLimit.OneOfTwo;
import flixel.addons.effects.chainable.FlxOutlineEffect;

using StringTools;

class CreditsState extends MusicBeatState
{
	//lol private
	private var grpOptions:MenuList;
	private var iconArray:Array<FlxSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var corn:FlxSprite;
	var iamscreamingandcreaming:FlxText;
	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var outlin:FlxOutlineEffect = new FlxOutlineEffect(NORMAL, FlxColor.WHITE, 12);
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	var hiimnint:FlxSprite;
	var sillytween:FlxTween;
	var sorryguys:FlxCamera; //:pensive:

	override function create()
	{	
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
			['libing',	'lib',		'director or some shit i forgot (im on crack while writing this)',							'https://www.youtube.com/channel/UCwH4gcjdN-gWPGunlBxAnQQ',	'51bd78', 'liber'],
			['plank','plank',    'coder + like composer + like the guy who turned this into a serious mod bravo plank!',		'https://plankdev.carrd.co/',		'6B327C',                          'plnk'],
			['Nick',    'dantesguy','coder + like artist + like animator, made opd sprites for mnalk lets fokin go mate innit',	'https://github.com/NickMGC',		'ffffff',                          'nick'],
			['FlyingFeltBoot','flyingfeltwhat','help with random bullshit like hypothesis dantes sprites i guess',	            'https://github.com/Nikerlo',		'7a4a35'],
			['Betopia', 'betty',    'so like, artist, i guess',		                                                            'https://twitter.com/betpowo',		'996666',                          'betp'],
			['chi',     'chii',     'artist, animator, stuff, gay sex i dunno',	                        						'https://www.tumblr.com/cheddarchiing?source=share', '8C00FF'],
			['Unholywanderer','mod','guy, did stuff, coded 1 single line in',	                        						'https://gamebanana.com/members/1908754', '1abc96',					   'holy'],
			['sinnvakr','sinn',     'i dunno this guy just randomly joined i dont know anything about him',	            		'https://www.youtube.com/@sinnvakr','c7feff',						   'sinn'],
			['wacker',  'wacker',	'coder, charter, stuff like that, i frogot sorry',	           							    'https://www.youtube.com/@wackynix171/videos','6c4bdf',				   'wack'],
			["Nint","Nint",          "joined, fucked up the source, fixed it, changed a number by .001, and pushed random shit daily",                              "https://www.bigrat.monster",		"ff8000",                          "mint"],
			['ToufG',		'touf',			'is it glade or toufg? idk i forgot anyway idk he composed or something',				'https://twitter.com/YtToufG',	'4b18d9', 'totoototoootofkgokfokgorkfogktfo'],
			['cicada',		'cicadascries',	'she va\'d gorflen and idk jkgsnlijkvhcnljkb,fcjxolkbhxnlkhbflhnblkvhkblgvhjojlvhn;ln', 'https://twitter.com/sillycicada/', 'a21df0', 'bug'],
			['maplesucks',	'maplse',		'compos\ni thikn',																		'https://fxtwitter.com/mapledope/',	'FF613A', 'mapl'],
			['SMB',			'SMB',			'allan please add details',																'https://smb-bio.carrd.co/',	'EC1C26', 'ssmsmmsmmmsmmmsmmmbmsmbmsmmbmsmbmmsmbmsmbmmsmbmsmmbsmmbmsmbmsmmbmmmbm'],
			[''],
			['d'],
			['d',	    'd',		'd (dont press enter)',						                                                'https://www.youtube.com/watch?v=mYiBdMnIT88',               'FFFF00',    'd'],
			['sans',	'snas',		'holy shit its sand undetale',						                                        'https://www.youtube.com/watch?v=Ixv7qcJ1AI4',               'FFFFFF',    'snans'],
			[''],
			['keoiki Team'],
			['Keoiki',				'keoiki',			'cat',		'https://twitter.com/Keoiki_',			'D2D2D2'],
			['Keoiki',				'keoiki',			'cat',		'https://twitter.com/Keoiki_',			'D2D2D2'],
			['Keoiki',				'keoiki',			'cat',		'https://twitter.com/Keoiki_',			'D2D2D2'],
			['Former keoiki'],
			['Keoiki',				'keoiki',			'cat',		'https://twitter.com/Keoiki_',			'D2D2D2'],
			[''],
			['keoiki Contributors'],
			['Keoiki',				'keoiki',			'cat',		'https://twitter.com/Keoiki_',			'D2D2D2'],
			['Keoiki',				'keoiki',			'cat',		'https://twitter.com/Keoiki_',			'D2D2D2'],
			['Keoiki',				'keoiki',			'cat',		'https://twitter.com/Keoiki_',			'D2D2D2'],
			['Keoiki',				'keoiki',			'cat',		'https://twitter.com/Keoiki_',			'D2D2D2'],
			['Keoiki',				'keoiki',			'cat',		'https://twitter.com/Keoiki_',			'D2D2D2'],
			['Shadow Mario',		'shadowmario',		'oh god',	'https://twitter.com/Shadow_Mario_',	'444444'],
			['Keoiki',				'keoiki',			'cat',		'https://twitter.com/Keoiki_',			'D2D2D2'],
			['Keoiki',				'keoiki',			(FlxG.random.bool(1) ? 'fakekeoiki' : 'cat'),		'https://twitter.com/Keoiki_',			'D2D2D2'],
			[''],
			["keioki Crew"],
			['Keoiki',				'keoiki',			'cat',		'https://twitter.com/Keoiki_',			'D2D2D2'],
			['Keoiki',				'keoiki',			'cat',		'https://twitter.com/Keoiki_',			'D2D2D2'],
			['Keoiki',				'keoiki',			'cat',		'https://twitter.com/Keoiki_',			'D2D2D2'],
			['Keoiki',				'keoiki',			'cat',		'https://twitter.com/Keoiki_',			'D2D2D2']
		];
		
		for(i in pisspoop)
			creditsStuff.push(i);
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:FlxText = new FlxText(0, 0, 500, creditsStuff[i][0]);
			optionText.setFormat(Paths.font('vcr.ttf'), 42, FlxColor.BLACK, LEFT, OUTLINE, FlxColor.WHITE);
			optionText.setBorderStyle(OUTLINE, 	FlxColor.WHITE, 4, 2);
			optionText.active = isSelectable;

			if(isSelectable) {
				var icon:FlxSprite = new FlxSprite(0, 0, Paths.image('creditorial!!!/' + creditsStuff[i][1]));
				if (creditsStuff[i][1] == 'plank') icon.setGraphicSize(150);
				icon.updateHitbox();
				icon.x = optionText.textField.textWidth + 12;
				icon.y = optionText.height / 2 - icon.height / 2;
				if (creditsStuff[i][1] == 'plank') icon.x += 15; // uhdagshgoievdhfigjefvhoijgrefhco9ughevfousxhougrhfsoughervoifejhgoevfdhuogvhef ocshigevrfhcsikjghvefjkchgikvefhcikhgvefiscuoigvefidhgiurefhsiygehgirevfhighverfuihgivefhjihrfschuoghefoshghrfucyyguorvhfscijgouieshoguirevhfosujghnerouijhogiuerjhcsnouigrehvoisuhreoiusgghgiefjgigefjgkugrsuixhgouwdshugwrhdscaughwrsvohngiorvlkshoilkrwhdsokhgguoishoiguirhsniughrnduihgrwuidhoiguwdhuhguowdhijghojishgijvcxhijghfczuoijkhouriklhhugrjkhnoguiorhefnduoghrfnohgreuofchguoirefhcnjighroeufiyhgujvrfhcuojgvrhefcuokhgvuwfhokghvuoeriwjhgugoievfhscoijgerushguivefhsouihjerupdhgouvredsuohgjihvrousichjlgnvreuoskhxngouvirkdhsnouifkhvrdoukgyhroueiskhgouvohhcklngvuliczhlngoufklhjmgojhvfoskjcmgjfwovfcsjovjwrndjiohfjvfohirwhiosd
	
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

		corn = new FlxSprite();

		changeSelection(grpOptions.curSelection);
		FlxG.cameras.add(sorryguys = new FlxCamera(0,0,FlxG.width,FlxG.height), false);
		sorryguys.bgColor.alpha = 0;
		hiimnint = new FlxSprite(0, 0, 'assets/images/creditorial!!!/yow/silly.jpg');
		hiimnint.setGraphicSize(FlxG.width, FlxG.height);
		hiimnint.updateHitbox();
		hiimnint.alpha = 0.00001;
		hiimnint.camera = sorryguys;
		add(hiimnint);
		super.create();
	}

	override public function beatHit() {
		super.beatHit();
		FlxG.camera.zoom += 0.01;
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		if (FlxG.sound.music.volume < 0.7)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, 0.16);

		if(!quitting)
		{
			if (controls.BACK)
			{
				if(colorTween != null)
					colorTween.cancel();
				FlxG.sound.play(Paths.sound('cancelMenu.wav'));
				MusicBeatState.switchState(new MainMenuState());
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
				quitting = true;
				FlxG.cameras.remove(sorryguys);
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
			remove(corn);
			remove(iamscreamingandcreaming);
		}

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();


		if (creditsStuff[curSelected][0] == "Nint"){ //now its not dependant on id i think
				//for some stupid fucking reason if i try using .visible the game kills itself so idk
				add(hiimnint);
				if (sillytween != null) sillytween.cancel();
				hiimnint.alpha = 0;
				sillytween = FlxTween.tween(hiimnint, {alpha: 1}, 0.25, {startDelay: 0.5, ease: FlxEase.sineIn});
			
		}
		else  if (members.contains(hiimnint)) remove(hiimnint);
	}

	function commitHateCrime(pathShit:String):Void {
		corn.loadGraphic(Paths.directGraphic(pathShit));
		add(corn);
		add(iamscreamingandcreaming);
		corn.scale.set(1, 1);
		corn.updateHitbox();

		if (corn.height > 353) corn.setGraphicSize(0, 353);
		corn.updateHitbox();
		corn.setPosition(FlxG.width * 0.7 - corn.width / 2, 0);
		corn.screenCenter(Y);
		// corn.pixels = outlin.apply(corn.pixels); // cffi is killing me
		iamscreamingandcreaming.fieldWidth = corn.width;
		iamscreamingandcreaming.setPosition(corn.x, corn.y);
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
