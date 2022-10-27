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
import lime.utils.Assets;
import flixel.FlxSubState;
import Achievements;
import PlayState;

using StringTools;

class AchievementsMenuState extends MusicBeatState
{
	#if ACHIEVEMENTS_ALLOWED
	var options:Array<String> = [];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	private var achievementArray:Array<AttachedAchievement> = [];
	private var achievementIndex:Array<Int> = [];
	private var descText:FlxText;
	private var nameText:FlxText;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Achievements Menu", null);
		#end

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBG);

		var menuBG2:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuGradient'));
		menuBG2.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG2.updateHitbox();
		menuBG2.screenCenter();
		menuBG2.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBG2);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		Achievements.loadAchievements();
		for (i in 0...Achievements.achievementsStuff.length) {
			if(!Achievements.achievementsStuff[i][3] || Achievements.achievementsMap.exists(Achievements.achievementsStuff[i][2])) {
				options.push(Achievements.achievementsStuff[i]);
				achievementIndex.push(i);
			}
		}

		for (i in 0...options.length) {
			
			var achieveName:String = Achievements.achievementsStuff[achievementIndex[i]][2];
			var optionText:Alphabet = new Alphabet(0 + i, 255, "", false, false);
			optionText.isMenuItemAchieve = true;
			optionText.x += 860;
			optionText.forceY = 225;
			optionText.xAdd = 600;
			grpOptions.add(optionText);

			var icon:AttachedAchievement = new AttachedAchievement(optionText.x + 700, optionText.y, achieveName);
			optionText.targetX = optionText.x * 2 + 300;
			icon.sprTracker = optionText;
			achievementArray.push(icon);
			add(icon);
		}

		nameText = new FlxText(150, 0, 980, "", 50);
		nameText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.YELLOW, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		nameText.scrollFactor.set();
		nameText.borderSize = 2.4;
		add(nameText);

		descText = new FlxText(150, 550, 980, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		changeSelection();

		#if android
		addVirtualPad(LEFT_RIGHT, B);
		#end

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		for (ii in 0...Achievements.achievementsStuff.length) {

			var tagK:String = Achievements.achievementsStuff[achievementIndex[ii]][2];

			if(!Achievements.isAchievementUnlocked(tagK)) {
				nameText.text = Achievements.achievementsStuff[achievementIndex[curSelected]][0];
			}
		}

		if (controls.UI_RIGHT_P) {
			changeSelection(-1);
		}
		if (controls.UI_LEFT_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
	}

	function changeSelection(change:Int = 0) {

		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetX = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetX == 0) {
				item.alpha = 1;
			}
		}

		for (i in 0...achievementArray.length) {
			achievementArray[i].alpha = 0.6;
			if(i == curSelected) {
				achievementArray[i].alpha = 1;
			}
		}

		descText.text = Achievements.achievementsStuff[achievementIndex[curSelected]][1];
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	}
	#end
}