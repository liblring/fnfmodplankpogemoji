package options;

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
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class BaseOptionsMenu extends MusicBeatSubstate {
	private var curOption:Option = null;
	private var curSelected:Int = 0;
	private var optionsArray:Array<Option>;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var checkboxGroup:FlxTypedGroup<CheckboxThingie>;
	private var grpTexts:FlxTypedGroup<AttachedText>;

	private var tenhourburstman:FlxSprite = null;
	private var descBox:FlxSprite;
	private var descText:FlxText;

	public var title:String;
	public var rpcTitle:String;

	public function new()
	{
		super();

		if(title == null) title = 'opitionions';
		if(rpcTitle == null) rpcTitle = 'opitionions menu';
		
		#if desktop
		DiscordClient.changePresence(rpcTitle, null);
		#end
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.screenCenter();
		bg.antialiasing = PlankPrefs.data.globalAntialiasing;
		add(bg);

		// avoids lagspikes while scrolling through menus!
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		grpTexts = new FlxTypedGroup<AttachedText>();
		add(grpTexts);

		checkboxGroup = new FlxTypedGroup<CheckboxThingie>();
		add(checkboxGroup);

		descBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		descBox.alpha = 0.6;
		add(descBox);

		var titleText:Alphabet = new Alphabet(75, 40, title, true);
		titleText.scaleX = 0.6;
		titleText.scaleY = 0.6;
		titleText.alpha = 0.4;
		add(titleText);

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		for (i in 0...optionsArray.length) {
			var optionText:Alphabet = new Alphabet(290, 260, optionsArray[i].name, false);
			optionText.isMenuItem = true;
			/*optionText.forceX = 300;
			optionText.yMult = 90;*/
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(optionsArray[i].type == 'bool') {
				var checkbox:CheckboxThingie = new CheckboxThingie(optionText.x - 105, optionText.y, optionsArray[i].getValue() == true);
				checkbox.sprTracker = optionText;
				checkbox.ID = i;
				checkboxGroup.add(checkbox);
			} else if (optionsArray[i].type != 'none') {
				optionText.x -= 80;
				optionText.startPosition.x -= 80;
				var valueText:AttachedText = new AttachedText('' + optionsArray[i].getValue(), optionText.width + 80);
				valueText.sprTracker = optionText;
				valueText.copyAlpha = true;
				valueText.ID = i;
				grpTexts.add(valueText);
				optionsArray[i].setChild(valueText);
			}

			if(optionsArray[i].showBoyfriend && tenhourburstman == null)
				reloadBoyfriend();
			updateTextFrom(optionsArray[i]);
		}

		changeSelection();
		reloadCheckboxes();
	}

	public function addOption(option:Option) {
		if(optionsArray == null || optionsArray.length < 1) optionsArray = [];
		optionsArray.push(option);
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	var holdValue:Float = 0;

	override function update(elapsed:Float) {
		if (controls.UI_UP_P)
			changeSelection(-1);
		if (controls.UI_DOWN_P)
			changeSelection(1);

		if (controls.BACK) {
			close();
			FlxG.sound.play(Paths.sound('cancelMenu.wav'));
		}

		if(nextAccept <= 0) {
			var usesCheckbox = curOption.type == 'bool';

			if (curOption.type == 'none') if (controls.ACCEPT) curOption.change();
			if(usesCheckbox) {
				if(controls.ACCEPT) {
					FlxG.sound.play(Paths.sound('scrollMenu.wav'));
					curOption.setValue((curOption.getValue() == true) ? false : true);
					curOption.change();
					reloadCheckboxes();
				}
			} else {
				if(controls.UI_LEFT || controls.UI_RIGHT) {
					var pressed = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
					if(holdTime > 0.5 || pressed) {
						if(pressed) {
							var add:Dynamic = null;
							if(curOption.type != 'string')
								add = controls.UI_LEFT ? -curOption.changeValue : curOption.changeValue;

							switch(curOption.type) {
								case 'int' | 'float' | 'percent':
									holdValue = curOption.getValue() + add;
									if(holdValue < curOption.minValue) holdValue = curOption.minValue;
									else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;

									switch(curOption.type) {
										case 'int':
											holdValue = Math.round(holdValue);
											curOption.setValue(holdValue);
										case 'float' | 'percent':
											holdValue = FlxMath.roundDecimal(holdValue, curOption.decimals);
											curOption.setValue(holdValue);
									}
								case 'string':
									var num:Int = curOption.curOption; //lol
									if(controls.UI_LEFT_P) --num;
									else num++;

									if(num < 0)
										num = curOption.options.length - 1;
									else if(num >= curOption.options.length)
										num = 0;

									curOption.curOption = num;
									curOption.setValue(curOption.options[num]); //lol
							}

							updateTextFrom(curOption);
							curOption.change();
							FlxG.sound.play(Paths.sound('scrollMenu.wav'));
						} else if(curOption.type != 'string') {
							holdValue += curOption.scrollSpeed * elapsed * (controls.UI_LEFT ? -1 : 1);
							if(holdValue < curOption.minValue) holdValue = curOption.minValue;
							else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;

							switch(curOption.type) {
								case 'int':
									curOption.setValue(Math.round(holdValue));
								case 'float' | 'percent':
									curOption.setValue(FlxMath.roundDecimal(holdValue, curOption.decimals));
							}
							updateTextFrom(curOption);
							curOption.change();
						}
					}

					if(curOption.type != 'string')
						holdTime += elapsed;
				} else if(controls.UI_LEFT_R || controls.UI_RIGHT_R) clearHold();
			}

			if(controls.RESET) {
				for (i in 0...optionsArray.length) {
					var leOption:Option = optionsArray[i];
					leOption.setValue(leOption.defaultValue);
					if(leOption.type != 'bool') {
						if(leOption.type == 'string')
							leOption.curOption = leOption.options.indexOf(leOption.getValue());
						updateTextFrom(leOption);
					}

					leOption.change();
				}
				FlxG.sound.play(Paths.sound('cancelMenu.wav'));
				reloadCheckboxes();
			}
		}

		if(nextAccept > 0)
			nextAccept -= 1;
		super.update(elapsed);
	}

	function updateTextFrom(option:Option) {
		var text:String = option.displayFormat;
		var val:Dynamic = option.getValue();
		if(option.type == 'percent') val *= 100;
		var def:Dynamic = option.defaultValue;
		option.text = text.replace('%v', Std.string(val)).replace('%d', Std.string(def));
	}

	function clearHold() {
		if(holdTime > 0.5)
			FlxG.sound.play(Paths.sound('scrollMenu.wav'));
		holdTime = 0;
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0) curSelected = optionsArray.length - 1;
		if (curSelected >= optionsArray.length) curSelected = 0;

		descText.text = optionsArray[curSelected].description;
		descText.screenCenter(Y);
		descText.y += 270;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
				item.alpha = 1;
		}

		for (text in grpTexts) {
			text.alpha = 0.6;
			if(text.ID == curSelected)
				text.alpha = 1;
		}

		descBox.setPosition(descText.x - 10, descText.y - 10);
		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();

		if(tenhourburstman != null)
			tenhourburstman.visible = optionsArray[curSelected].showBoyfriend;
		curOption = optionsArray[curSelected]; //shorter lol
		FlxG.sound.play(Paths.sound('scrollMenu.wav'));
	}

	public function reloadBoyfriend() {
		var wasVisible:Bool = false;

		if(tenhourburstman != null) {
			wasVisible = tenhourburstman.visible;
			tenhourburstman.kill();
			remove(tenhourburstman);
			tenhourburstman.destroy();
		}

		tenhourburstman = new FlxSprite(0, 0);
		tenhourburstman.frames = Paths.getSparrowAtlas('optinions/10hbm');
		tenhourburstman.animation.addByPrefix('10 burst man', 'hoodirony', 16);
		tenhourburstman.animation.play('10 burst man');
		tenhourburstman.setGraphicSize(FlxG.width, FlxG.height);
		tenhourburstman.updateHitbox();
		tenhourburstman.x = tenhourburstman.y = 0;
		insert(1, tenhourburstman);
		tenhourburstman.visible = wasVisible;
	}

	function reloadCheckboxes()
		for (checkbox in checkboxGroup)
			checkbox.daValue = (optionsArray[checkbox.ID].getValue() == true);
}